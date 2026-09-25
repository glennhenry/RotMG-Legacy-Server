package encore.fancam.impl

import encore.EncoreFancamConfig
import encore.fancam.Tags
import encore.fancam.events.*
import encore.fancam.formatter.ConsoleTrackEventFancamFormatter
import encore.fancam.formatter.FancamFormatter
import encore.fancam.formatter.LogEventFancamFormatter
import encore.fancam.formatter.TrackEventFancamFormatter
import encore.fancam.producer.ConsoleFancamProducer
import encore.fancam.producer.FancamProducer
import encore.fancam.producer.FileFancamProducer
import encore.fancam.utils.SourceCallResolver
import encore.time.TimeCenter
import java.util.concurrent.Executors
import java.util.concurrent.LinkedBlockingQueue
import java.util.concurrent.TimeUnit
import java.util.concurrent.atomic.AtomicInteger

/**
 * Default implementation of fancam template.
 *
 * ## Overview
 *
 * 1. Supports basic logging through [trace], [debug], [info], [warn], and [error].
 * 2. Logging call can be done through builder DSL through [event].
 * 3. Structured logging uses the [track] method.
 *
 * Require [EncoreFancamConfig] to configure the logger behavior.
 *
 * ## Usage
 *
 * ### 1. Basic logging
 *
 * Any simple print at various level with categorical info tag:
 * ```kotlin
 * const val SubunitTag = "Subunit"
 * const val MultipleTag = "Game,Player,Inventory"
 *
 * Fancam.warn(SubunitTag) { "Subunit x under problem." }
 * Fancam.warn(MultipleTag) { "Subunit x under problem." }
 * ```
 *
 * Under basic logging, log will be truncated if it exceeds the maximum character.
 * Use the builder below to ensure everything is printed fully.
 *
 * ### 2. Advanced logging with builder DSL
 *
 * For more advanced config such as file target and to toggle [LogEvent.logFull].
 * ```kotlin
 * fancam.event(Level.Info, "InventorySubunit")
 *       .message { "subunit working..." }
 *       .toFile("InventorySubunit")
 *       .log(full = true)
 * ```
 *
 * ### 3. Structured logging with builder DSL
 *
 * To write a structured log of [TrackEvent].
 * ```kotlin
 * // recorded to default file `events.jsonl`, not logged
 * Fancam.track("SystemHealth")
 *       .data("heat", 12)
 *       .data("playerOnline", 100)
 *       .tags("system", "metric")
 *       .note { if (heat > 10) { "WARNING OVERHEAT" } else "" }
 *       .record()
 *
 * // recorded to `loots.jsonl`, logged with info level
 * Fancam.track("PlayerLoot")
 *       .playerId("pid123")
 *       .username("playerABC")
 *       .data("loot", "bread")
 *       .tags("player", "rng")
 *       .route("loots")
 *       .record()
 *       .log(Level.Info, full = false)
 * ```
 *
 * ## Features
 *
 * ### Beautiful log
 *
 * - Display a formatted timestamp of when the log call was invoked.
 * - Show a hyperlink to the source file and line number of the log caller.
 * - Allow ANSI coloring for the level label with [EncoreFancamConfig.colorEnabled].
 * - Truncation of log message (per-newline) depending on [LogEvent.logFull]
 *   and [EncoreFancamConfig.maxLineLength].
 *
 * ### Three output targets
 *
 * Any log call is printed to the console, optionally to the file via [LogEvent.targetFile]
 * or for structured logging via [TrackEvent.route]. Log events are also sent to client
 * via ... (todo).
 *
 * #### Client output
 *
 * An external web client to see advanced version of the logger is available at ...
 * Allows for filtration, search, and etc.
 *
 * ## Implementation Details
 *
 * Process log calls with a blocking queue to ensure order. The blocking mechanism does not
 * disturb the main thread because it is done on separate thread.
 * Log calls should be processed completely before the app is terminated with the shutdown
 * hook enabled. See [eventQueue] and the following code for details.
 *
 * Below is the spec of [FancamFormatter] and [FancamProducer] used for
 * log or track event and console or file output.
 *
 * 1. `LogEvent to Console`   : [LogEventFancamFormatter] + [ConsoleFancamProducer]
 * 2. `LogEvent to File`      : [LogEventFancamFormatter] (with `isFileTarget` flag) + [FileFancamProducer]
 * 3. `TrackEvent to Console` : [ConsoleTrackEventFancamFormatter] + [ConsoleFancamProducer] (reuse)
 * 4. `TrackEvent to File`    : [TrackEventFancamFormatter] + [FileFancamProducer]
 *
 */
class OfficialFancam(private val config: EncoreFancamConfig) : FancamTemplate {
    private val sourceResolver: SourceCallResolver = SourceCallResolver()

    // LogEvent formatters
    private val consoleLogFormatter = LogEventFancamFormatter(config, isFileTarget = false)
    private val fileLogFormatter = LogEventFancamFormatter(config, isFileTarget = true)

    // TrackEvent formatters
    private val consoleTrackFormatter = ConsoleTrackEventFancamFormatter()
    private val fileTrackFormatter = TrackEventFancamFormatter()

    // LogEvent producers
    private val consoleLogProducer = ConsoleFancamProducer(consoleLogFormatter)
    private val fileLogProducer = FileFancamProducer(config, fileLogFormatter)

    // TrackEvent producers
    // consoleTrackProducer reuses consoleLogProducer
    private val fileTrackProducer = FileFancamProducer(config, fileTrackFormatter)

    override fun trace(tag: String, msg: () -> String) {
        if (Level.Trace < config.level.toLogLevel()) return
        log(create(msg, tag, Level.Trace))
    }

    override fun debug(tag: String, msg: () -> String) {
        if (Level.Debug < config.level.toLogLevel()) return
        log(create(msg, tag, Level.Debug))
    }

    override fun info(tag: String, msg: () -> String) {
        if (Level.Info < config.level.toLogLevel()) return
        log(create(msg, tag, Level.Info))
    }

    override fun warn(tag: String, msg: () -> String) {
        if (Level.Warn < config.level.toLogLevel()) return
        log(create(msg, tag, Level.Warn))
    }

    override fun error(throwable: Throwable?, tag: String, msg: () -> String) {
        if (Level.Error < config.level.toLogLevel()) return
        log(create(msg, tag, Level.Error, throwable))
    }

    private fun create(
        msg: () -> String, tag: String,
        level: Level, throwable: Throwable? = null
    ): LogEvent = LogEvent(
        message = msg,
        timestamp = TimeCenter.now(),
        level = level,
        tag = tag,
        logFull = false,
        source = sourceResolver.resolve(),
        throwable = throwable,
        targetFile = null
    )

    private fun log(event: LogEvent, fileOnlyOutput: Boolean = false) {
        pendingEvents.incrementAndGet()
        eventQueue.offer(LogQueueEvent(event, fromTrackEvent = false, fileOnlyOutput))
    }

    override fun event(level: Level, tag: String): LogEventBuilder {
        return LogEventBuilder(level, tag, sourceResolver.resolve()) { event, fileOnlyOutput ->
            if (event.level == Level.Off && !event.tag.contains("kp")) {
                warn(Tags.Fancam) { "Log with Level.Off is not intended to be used." }
            } else {
                log(event, fileOnlyOutput)
            }
        }
    }

    override fun track(name: String): TrackEventBuilder {
        return TrackEventBuilder(
            name = name,
            onRecordCalled = {
                pendingEvents.incrementAndGet()
                eventQueue.offer(TrackQueueEvent(it))
            },
            onLogCalled = { trackEvent, level, logFull ->
                pendingEvents.incrementAndGet()
                eventQueue.offer(
                    LogQueueEvent(
                        LogEvent(
                            message = { consoleTrackFormatter.format(trackEvent) },
                            timestamp = trackEvent.timestamp,
                            level = level,
                            tag = trackEvent.tags.tagsToCommaSeparated(),
                            logFull = logFull,
                            source = trackEvent.source,
                            targetFile = trackEvent.route
                        ), fromTrackEvent = true, fileOnlyOutput = false
                        // track event is only outputted to file via onRecordCalled
                        // fromTrackEvent flag prevent the console log event
                        // from producing file output
                    )
                )
            }
        )
    }

    // log calls (e.g., Fancam.info) creates a log event, increment a counter (pendingEvents),
    // and add the event to a blocking queue.
    // The queue is processed continuously in sync which calls the log producers and formatters.
    // On app shutdown, the logger is given time to finish the pending events, ensuring
    // no log gets cut off.
    private val eventQueue = LinkedBlockingQueue<QueueEvent>()
    private val executor = Executors.newSingleThreadExecutor()
    private val pendingEvents = AtomicInteger(0)

    init {
        startConsumer()
        Runtime.getRuntime().addShutdownHook(Thread {
            executor.shutdown()
            while (pendingEvents.get() > 0) {
                Thread.sleep(10)
            }
            executor.awaitTermination(1, TimeUnit.SECONDS)
        })
    }

    private fun startConsumer() {
        executor.execute {
            while (!Thread.currentThread().isInterrupted) {
                try {
                    val event = eventQueue.take()
                    process(event)
                } catch (e: InterruptedException) {
                    e.printStackTrace()
                    Thread.currentThread().interrupt()
                }
            }
        }
    }

    private fun process(event: QueueEvent) {
        try {
            when (event) {
                is LogQueueEvent -> {
                    val log = event.event
                    if (!event.fileOnlyOutput) {
                        consoleLogProducer.produce(log)
                    }
                    if (log.filename != null && !event.fromTrackEvent) {
                        fileLogProducer.produce(log)
                    }
                    if (event.fileOnlyOutput && log.filename == null) {
                        warn(Tags.Fancam) { "Unexpected condition fileOnlyOutput=$event.fileOnlyOutput but filename=${log.filename}" }
                    }
                }

                is TrackQueueEvent -> {
                    fileTrackProducer.produce(event.event)
                }
            }
        } catch (e: Throwable) {
            e.printStackTrace()
        } finally {
            pendingEvents.decrementAndGet()
        }
    }
}

sealed interface QueueEvent
data class LogQueueEvent(val event: LogEvent, val fromTrackEvent: Boolean, val fileOnlyOutput: Boolean) : QueueEvent
data class TrackQueueEvent(val event: TrackEvent) : QueueEvent
