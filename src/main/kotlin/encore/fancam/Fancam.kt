package encore.fancam

import encore.fancam.events.Level
import encore.fancam.events.LogEvent
import encore.fancam.events.TrackEvent
import encore.fancam.events.LogEventBuilder
import encore.fancam.events.TrackEventBuilder
import encore.fancam.impl.FancamTemplate
import encore.fancam.impl.OfficialFancam
import encore.fancam.impl.RehearsalFancam

const val LOG_FILE_EXTENSION = "log"
const val TRACK_FILE_EXTENSION = "jsonl"
const val LOG_FILE_DIRECTORY = ".logs"

/**
 * A globally accessible facade for [Fancam].
 *
 * Provides a static entry point for logging and tracking events
 * through a [FancamTemplate] implementation.
 *
 * **Initialization:** Should be initialized before use via [initialize]
 * by passing a concrete [FancamTemplate].
 *
 * **Default behavior:** By default, the implementation is [RehearsalFancam],
 * which is a simple, no-dependency version typically used for testing
 * or early bootstrap. This default can later be upgraded to a full-featured
 * implementation.
 *
 * **Recommended implementation:** [OfficialFancam].
 */
object Fancam {
    private var initialized = false
    // to avoid annoying must init; also for default in tests
    private var fancam: FancamTemplate = RehearsalFancam()

    /**
     * Initialize the global [Fancam] instance.
     *
     * @param fancam The [FancamTemplate] implementation to use.
     */
    fun initialize(fancam: FancamTemplate) {
        if (initialized) {
            warn { "Fancam is already initialized." }
            return
        }
        this.fancam = fancam
        if (fancam is OfficialFancam) {
            INDENT = " ".repeat(60)
        } else if (fancam is RehearsalFancam) {
            INDENT = " ".repeat(21)
        }
    }

    /**
     * Log with the [Level.Trace], category [tag], and lazy message of [msg].
     */
    fun trace(tag: String = "", msg: () -> String) = fancam.trace(tag, msg)

    /**
     * Log with the [Level.Debug], category [tag], and lazy message of [msg].
     */
    fun debug(tag: String = "", msg: () -> String) = fancam.debug(tag, msg)

    /**
     * Log with the [Level.Info], category [tag], and lazy message of [msg].
     */
    fun info(tag: String = "", msg: () -> String) = fancam.info(tag, msg)

    /**
     * Log with the [Level.Warn], category [tag], and lazy message of [msg].
     */
    fun warn(tag: String = "", msg: () -> String) = fancam.warn(tag, msg)

    /**
     * Log with the [Level.Error], category [tag], and lazy message of [msg].
     */
    fun error(throwable: Throwable? = null, tag: String = "", msg: () -> String) = fancam.error(throwable, tag, msg)

    /**
     * Create a logging event for [LogEvent] with the [LogEventBuilder].
     */
    fun event(level: Level, tag: String = ""): LogEventBuilder = fancam.event(level, tag)

    /**
     * Create a structured logging event for [TrackEvent] with the [TrackEventBuilder].
     */
    fun track(name: String): TrackEventBuilder = fancam.track(name)
}

/**
 * Blank spaces to include in the log message when you are logging with
 * multiple lines and wants the next line to align with the upper log call.
 *
 * When fancam is changed on [Fancam] object, this indent will be adjusted.
 * However, it is only hardcoded to rehearsal (21) and official fancam (60).
 * The number of indent should be modified when formatting
 * changes (e.g., padding length, timestamp formatting).
 *
 * ### Details
 *
 * The amount of indent is the amount of characters printed before the
 * actual log message.
 *
 * ```
 * [11:38:33.389](      InstallEncore.kt:96)[INFO ][startup___] Running server on developmentMode
 * ________________________________________60 blank spaces_____ Next line of the log message
 * ```
 *
 * This includes: timestamp, source, tag, label, and separator symbols.
 */
var INDENT = " ".repeat(21)
