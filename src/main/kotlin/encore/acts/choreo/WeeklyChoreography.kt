package encore.acts.choreo

import SystemTimezone
import encore.acts.ActConcept
import encore.acts.StageAct
import encore.time.model.DayOfWeek
import encore.time.model.TimeOfDay
import encore.time.model.nextOccurrence
import java.time.ZoneId

/**
 * Schedules a [StageAct] to perform once per week at a specific
 * [DayOfWeek] and [TimeOfDay].
 *
 * Perform is aligned to wall-clock time and repeats indefinitely
 * (unless explicitly stopped).
 *
 * @param T The [ActConcept] associated with the [StageAct].
 * @property runAtDay The day of the week on which the act should perform.
 * @property runAtTime The time of day at which the act should perform.
 */
data class WeeklyChoreography<T : ActConcept>(
    val runAtDay: DayOfWeek,
    val runAtTime: TimeOfDay,
    val timezone: ZoneId = SystemTimezone
) : Choreography<T> {
    override fun next(concept: T, context: ChoreographyContext): Long {
        val nextOccurence = runAtDay.nextOccurrence(runAtTime, context.currentMillis, timezone)
        val timeUntilNextOccurence = nextOccurence - context.currentMillis
        return timeUntilNextOccurence
    }
}
