package encore.fancam.formatter

import encore.fancam.events.LogEvent
import encore.fancam.events.TrackEvent

/**
 * Represent a formatter for log or track event.
 *
 * Implementation provide [format] method that convert the [T] type of event
 * into string representation to be printed or written to a file.
 *
 * Examples:
 * - [LogEventFancamFormatter]
 * - [TrackEventFancamFormatter]
 * - [ConsoleTrackEventFancamFormatter]
 *
 * @param T Generic type of the event which should be limited to [LogEvent] or [TrackEvent].
 */
interface FancamFormatter<T> {
    fun format(event: T): String
}
