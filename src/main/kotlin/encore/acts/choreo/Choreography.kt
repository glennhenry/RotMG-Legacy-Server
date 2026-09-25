package encore.acts.choreo

import encore.acts.ActConcept
import encore.acts.StageAct
import encore.time.model.DayOfWeek
import encore.time.model.TimeOfDay

/**
 * Defines how a [StageAct] is scheduled over time.
 *
 * This determines *when* an act should perform, but not *what* it does.
 *
 * Built-in implementations:
 * - [BasicChoreography]: Covers simple runtime scheduling based on an initial delay
 *   and a fixed perform pattern (once, repeat, or forever).
 * - [DailyChoreography]: Schedules perform at a fixed [TimeOfDay] every day.
 * - [WeeklyChoreography]: Schedules perform at a fixed [DayOfWeek] and [TimeOfDay].
 *
 * More advanced or dynamic scheduling requires manual implementation.
 *
 * @param T the type of [ActConcept] which must be same as the one defined in [StageAct].
 */
interface Choreography<T : ActConcept> {
    /**
     * Computes the delay time until the next perform.
     *
     * @param concept The act input used to derive scheduling decisions.
     * @param context Execution and timing information.
     * @return The delay amount, or `null` if no further performs should occur.
     */
    fun next(concept: T, context: ChoreographyContext): Long?
}

/**
 * Execution and time context for [Choreography].
 *
 * @property currentMillis The current time in epoch milliseconds.
 * @property performCount Number of times the act has already performed so far by `onPerform` call.
 * @property startedAt Epoch millis of when the act was called to run.
 * @property firstPerformAt Epoch millis of the first time when perform was called.
 *                          `null` if it hasn't been called before.
 * @property previousPerformAt Epoch millis of when previous perform was called.
 *                             `null` if this is the first.
 */
data class ChoreographyContext(
    val currentMillis: Long,
    val performCount: Int,
    val startedAt: Long,
    val firstPerformAt: Long?,
    val previousPerformAt: Long?
)
