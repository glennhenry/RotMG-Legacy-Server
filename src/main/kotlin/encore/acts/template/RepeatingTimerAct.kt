package encore.acts.template

import encore.acts.ActConcept
import encore.acts.StageAct
import encore.acts.choreo.BasicChoreography
import encore.acts.choreo.Choreography
import encore.acts.choreo.PerformMode
import kotlin.time.Duration

/**
 * A built-in stage act for simple repeating timers.
 *
 * This will run after the initial delay of [RepeatingTimerConcept.initialDelay].
 * and will perform repeatedly for [RepeatingTimerConcept.repetition] between interval of
 * [RepeatingTimerConcept.interval].
 */
class RepeatingTimerAct : StageAct<RepeatingTimerConcept> {
    override val enableLogging: Boolean = false

    override fun choreography(concept: RepeatingTimerConcept): Choreography<RepeatingTimerConcept> {
        return BasicChoreography(
            initialDelay = concept.initialDelay,
            performMode = PerformMode.Repeat(concept.repetition, concept.interval)
        )
    }

    override suspend fun perform(concept: RepeatingTimerConcept, performNumber: Int) {
        concept.onPerform(performNumber)
    }
}

/**
 * Input for [RepeatingTimerAct].
 *
 * @property initialDelay The initial time to wait before first execution.
 * @property repetition The amount of repetition to do, which excludes the first execution.
 * @property interval Time to wait on between each repetition.
 * @property onPerform Block of code to run on each execution.
 */
data class RepeatingTimerConcept(
    val initialDelay: Duration,
    val repetition: Int,
    val interval: Duration,
    val onPerform: suspend (Int) -> Unit
) : ActConcept
