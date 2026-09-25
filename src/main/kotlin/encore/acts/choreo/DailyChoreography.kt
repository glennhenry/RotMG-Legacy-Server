package encore.acts.choreo

import SystemTimezone
import encore.acts.ActConcept
import encore.acts.StageAct
import encore.time.model.TimeOfDay
import encore.time.model.nextOccurrence
import java.time.ZoneId

/**
 * Schedules a [StageAct] to perform once per day at a fixed [TimeOfDay].
 *
 * Perform is aligned to wall-clock time and repeats indefinitely
 * (unless explicitly stopped).
 *
 * @param T The [ActConcept] associated with the [StageAct].
 * @property runAt The time of day at which the act should perform.
 */
data class DailyChoreography<T : ActConcept>(
    val runAt: TimeOfDay,
    val timezone: ZoneId = SystemTimezone
) : Choreography<T> {
    override fun next(concept: T, context: ChoreographyContext): Long {
        val nextOccurence = runAt.nextOccurrence(context.currentMillis, timezone)
        val timeUntilNextOccurence = nextOccurence - context.currentMillis
        return timeUntilNextOccurence
    }
}
