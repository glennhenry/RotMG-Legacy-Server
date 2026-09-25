package encore.fancam.formatter

import encore.serialization.AnyMapSerializer
import encore.fancam.events.TrackEvent
import kotlinx.serialization.json.Json

/**
 * Formatter implementation for track event tailored for console output.
 *
 * Format is implemented by creating a string format containing the event name,
 * event note, then followed by the JSON encoded event data.
 */
class ConsoleTrackEventFancamFormatter : FancamFormatter<TrackEvent> {
    private val jsonSerializer = Json { prettyPrint = false }

    override fun format(event: TrackEvent): String {
        return "[TrackEvent:${event.name}] ${event.note()} ${
            jsonSerializer.encodeToString(
                AnyMapSerializer,
                event.data
            )
        }"
    }
}
