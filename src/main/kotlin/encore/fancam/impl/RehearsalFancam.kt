package encore.fancam.impl

import encore.fancam.Fancam
import encore.fancam.events.*
import encore.fancam.formatter.toLimitedString
import encore.serialization.toJsonElement
import encore.time.TimeCenter
import kotlinx.serialization.json.Json
import java.text.SimpleDateFormat

/**
 * A minimal fancam implementation intended for bootstrap or testing.
 *
 * This implementation is simple, lightweight, and dependency-less.
 *
 * - On each call to [trace], [debug], [info], [warn], [error], the log events
 *   are recorded. Likewise for [event] (whenever `log` is called) and
 *   [track] (whenever `log` or `record` is called).
 * - A `log()` call to track event does not get recorded to log event,
 *   but to track event instead.
 * - Provides access to them for assertion such as [takeLastLogTrace],
 *   [takeLastTrackTrace], [assertLogHas], [assertTrackHas].
 * - Minimal formatting: no color, never truncate.
 * - Does not implement file and client target.
 *
 * **Important**: if you are using `RehearsalFancam` to assert log calls,
 * you must still call [Fancam.initialize] to pass a `RehearsalFancam`.
 * This ensures that every systems uses the same underlying `RehearsalFancam`
 * implementation from the [Fancam] facade. A helper for this is available
 * in `test.kotlin.testHelper`.
 *
 * Example:
 * ```
 * // logevent
 * [12:32:11.444][D] message
 *
 * // trackevent
 * [12:32:11.444][D] { playerId: "abc", username: "def" }
 * ```
 */
class RehearsalFancam : FancamTemplate {
    private val tracelog = mutableListOf<LogEvent>()
    private val debuglog = mutableListOf<LogEvent>()
    private val infolog = mutableListOf<LogEvent>()
    private val warnlog = mutableListOf<LogEvent>()
    private val errorlog = mutableListOf<LogEvent>()

    private val tracetrack = mutableListOf<TrackEvent>()
    private val debugtrack = mutableListOf<TrackEvent>()
    private val infotrack = mutableListOf<TrackEvent>()
    private val warntrack = mutableListOf<TrackEvent>()
    private val errortrack = mutableListOf<TrackEvent>()

    private val date = SimpleDateFormat("HH:mm:ss.SSS")
    private val json = Json { prettyPrint = false }

    private fun formatLog(event: LogEvent): String {
        return buildString {
            append("[${date.format(event.timestamp)}][${event.level.label()}] ${event.message()}")
            if (event.level == Level.Error && event.throwable != null) {
                appendLine()
                appendLine(event.throwable.toLimitedString(false))
            }
        }
    }

    private fun formatTrack(event: TrackEvent, level: Level): String {
        val data = event.data.toJsonElement(useReflection = false)
        return "[${date.format(event.timestamp)}][${level.label()}] ${json.encodeToString(data)}"
    }

    override fun trace(tag: String, msg: () -> String) {
        create(msg, tag, Level.Trace).also {
            log(it)
        }
    }

    override fun debug(tag: String, msg: () -> String) {
        create(msg, tag, Level.Debug).also {
            log(it)
        }
    }

    override fun info(tag: String, msg: () -> String) {
        create(msg, tag, Level.Info).also {
            log(it)
        }
    }

    override fun warn(tag: String, msg: () -> String) {
        create(msg, tag, Level.Warn).also {
            log(it)
        }
    }

    override fun error(throwable: Throwable?, tag: String, msg: () -> String) {
        create(msg, tag, Level.Error, throwable).also {
            log(it)
        }
    }

    private fun create(
        msg: () -> String, tag: String,
        level: Level, throwable: Throwable? = null
    ): LogEvent = LogEvent(
        message = msg,
        timestamp = TimeCenter.now(),
        level = level,
        tag = tag,
        logFull = true,
        source = null,
        throwable = throwable,
        targetFile = null
    )

    private fun log(event: LogEvent, add: Boolean = true) {
        if (add) {
            addToLogEvent(event.level, event)
        }
        println(formatLog(event))
    }

    override fun event(level: Level, tag: String): LogEventBuilder {
        return LogEventBuilder(level, tag, null) { event, _ ->
            if (level == Level.Off && !tag.contains("kp")) return@LogEventBuilder
            log(event)
        }
    }

    override fun track(name: String): TrackEventBuilder {
        return TrackEventBuilder(
            name = name,
            onRecordCalled = { println("TrackEvent.onRecordCalled: NOT IMPLEMENTED") },
            onLogCalled = { trackEvent, level, logFull ->
                addToTrackEvent(level, trackEvent)
                log(
                    LogEvent(
                        message = { formatTrack(trackEvent, level) },
                        timestamp = trackEvent.timestamp,
                        level = level,
                        tag = trackEvent.tags.tagsToCommaSeparated(),
                        logFull = logFull,
                        source = trackEvent.source,
                        throwable = null,
                        targetFile = trackEvent.route
                    ), add = false
                )
            }
        )
    }

    private fun addToLogEvent(level: Level, event: LogEvent) {
        when (level) {
            Level.Trace -> tracelog.add(event)
            Level.Debug -> debuglog.add(event)
            Level.Info -> infolog.add(event)
            Level.Warn -> warnlog.add(event)
            Level.Error -> errorlog.add(event)
            Level.Off -> {}
        }
    }

    private fun addToTrackEvent(level: Level, event: TrackEvent) {
        when (level) {
            Level.Trace -> tracetrack.add(event)
            Level.Debug -> debugtrack.add(event)
            Level.Info -> infotrack.add(event)
            Level.Warn -> warntrack.add(event)
            Level.Error -> errortrack.add(event)
            Level.Off -> {}
        }
    }

    /**
     * Returns the last [n] trace calls, or all entries if fewer are available.
     */
    fun takeLastLogTrace(n: Int): List<LogEvent> = tracelog.takeLast(n)

    /**
     * Returns the last [n] debug calls, or all entries if fewer are available.
     */
    fun takeLastLogDebug(n: Int): List<LogEvent> = debuglog.takeLast(n)

    /**
     * Returns the last [n] info calls, or all entries if fewer are available.
     */
    fun takeLastLogInfo(n: Int): List<LogEvent> = infolog.takeLast(n)

    /**
     * Returns the last [n] warn calls, or all entries if fewer are available.
     */
    fun takeLastLogWarn(n: Int): List<LogEvent> = warnlog.takeLast(n)

    /**
     * Returns the last [n] error calls, or all entries if fewer are available.
     */
    fun takeLastLogError(n: Int): List<LogEvent> = errorlog.takeLast(n)

    /**
     * Returns the last [n] trace calls, or all entries if fewer are available.
     */
    fun takeLastTrackTrace(n: Int): List<TrackEvent> = tracetrack.takeLast(n)

    /**
     * Returns the last [n] debug calls, or all entries if fewer are available.
     */
    fun takeLastTrackDebug(n: Int): List<TrackEvent> = debugtrack.takeLast(n)

    /**
     * Returns the last [n] info calls, or all entries if fewer are available.
     */
    fun takeLastTrackInfo(n: Int): List<TrackEvent> = infotrack.takeLast(n)

    /**
     * Returns the last [n] warn calls, or all entries if fewer are available.
     */
    fun takeLastTrackWarn(n: Int): List<TrackEvent> = warntrack.takeLast(n)

    /**
     * Returns the last [n] error calls, or all entries if fewer are available.
     */
    fun takeLastTrackError(n: Int): List<TrackEvent> = errortrack.takeLast(n)

    /**
     * To assert whether the recorded log events of [withLevel] matches some predicate
     * (e.g., string contains something) within any of the [withinLastN] message.
     *
     * @throws AssertionError if fail to match the predicate.
     */
    fun assertLogHas(withLevel: Level, withinLastN: Int, predicate: (LogEvent) -> Boolean): Boolean {
        val assert = when (withLevel) {
            Level.Trace -> takeLastLogTrace(withinLastN).any { predicate(it) }
            Level.Debug -> takeLastLogDebug(withinLastN).any { predicate(it) }
            Level.Info -> takeLastLogInfo(withinLastN).any { predicate(it) }
            Level.Warn -> takeLastLogWarn(withinLastN).any { predicate(it) }
            Level.Error -> takeLastLogError(withinLastN).any { predicate(it) }
            Level.Off -> {
                true
            }
        }

        if (!assert) {
            throw AssertionError("Failed to match predicate of $withLevel in the last $withinLastN calls")
        } else {
            return true
        }
    }

    /**
     * To assert whether the [lastN] message has track event of [level]
     * and match some predicate (e.g., data map contains something).
     *
     * @throws AssertionError if fail to match the predicate.
     */
    fun assertTrackHas(level: Level, lastN: Int, predicate: (Map<String, Any>) -> Boolean): Boolean {
        val assert = when (level) {
            Level.Trace -> takeLastTrackTrace(lastN).any { predicate(it.data) }
            Level.Debug -> takeLastTrackDebug(lastN).any { predicate(it.data) }
            Level.Info -> takeLastTrackInfo(lastN).any { predicate(it.data) }
            Level.Warn -> takeLastTrackWarn(lastN).any { predicate(it.data) }
            Level.Error -> takeLastTrackError(lastN).any { predicate(it.data) }
            Level.Off -> {
                true
            }
        }

        if (!assert) {
            throw AssertionError("Failed to match predicate of $level in the last $lastN calls")
        } else {
            return true
        }
    }

    /**
     * Clear all saved log and track entries.
     */
    fun clearAll() {
        tracelog.clear()
        debuglog.clear()
        infolog.clear()
        warnlog.clear()
        errorlog.clear()
        tracetrack.clear()
        debugtrack.clear()
        infotrack.clear()
        warntrack.clear()
        errortrack.clear()
    }
}
