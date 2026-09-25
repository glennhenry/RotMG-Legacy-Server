package encore.fancam.impl

import encore.fancam.events.Level
import encore.fancam.events.LogEvent
import encore.fancam.events.LogEventBuilder
import encore.fancam.events.TrackEvent
import encore.fancam.events.TrackEventBuilder

/**
 * Template of a fancam (logger).
 *
 * Implementations allow logging through:
 * 1. Simple log call based on the five log levels: [trace], [debug], [info], [warn], [error].
 * 2. More detailed log creation with [LogEventBuilder] through [event].
 * 3. Structured logging with [TrackEventBuilder] through [track].
 *
 * Parameter details:
 * - `tag` represent categorical or classification information for the log call.
 * - `msg` the log message evaluated lazily.
 */
interface FancamTemplate {
    fun trace(tag: String = "", msg: () -> String)
    fun debug(tag: String = "", msg: () -> String)
    fun info(tag: String = "", msg: () -> String)
    fun warn(tag: String = "", msg: () -> String)
    fun error(throwable: Throwable? = null, tag: String = "", msg: () -> String)

    /**
     * Construct a [LogEvent] in DSL builder style with [LogEventBuilder].
     *
     * @param level Set the log event severity.
     */
    fun event(level: Level, tag: String = ""): LogEventBuilder

    /**
     * Construct a [TrackEvent] in DSL builder style with [TrackEventBuilder].
     *
     * @param name An identifier for the track event.
     */
    fun track(name: String): TrackEventBuilder
}
