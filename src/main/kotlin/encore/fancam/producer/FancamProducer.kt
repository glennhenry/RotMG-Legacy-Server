package encore.fancam.producer

import encore.fancam.events.LogEvent
import encore.fancam.events.TrackEvent

/**
 * Represent a producer for log or track event.
 *
 * Implementation defines how a log or track event should be outputted
 * into a particular target.
 *
 * Examples:
 * - [ConsoleFancamProducer]
 * - [FileFancamProducer]
 *
 * @param T Generic type which should be limited to [LogEvent] or [TrackEvent].
 */
interface FancamProducer<T> {
    fun produce(event: T)
}
