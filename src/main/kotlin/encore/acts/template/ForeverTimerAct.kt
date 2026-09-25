package encore.acts.template

import encore.acts.ActConcept
import encore.acts.StageAct
import encore.acts.choreo.BasicChoreography
import encore.acts.choreo.Choreography
import encore.acts.choreo.PerformMode
import kotlin.time.Duration

/**
 * A built-in stage act for simple forever timers.
 *
 * This will run after the initial delay of [ForeverTimerConcept.initialDelay].
 * and will perform repeatedly forever between interval of [ForeverTimerConcept.interval].
 */
class ForeverTimerAct : StageAct<ForeverTimerConcept> {
    override val enableLogging: Boolean = false

    override fun choreography(concept: ForeverTimerConcept): Choreography<ForeverTimerConcept> {
        return BasicChoreography(
            initialDelay = concept.initialDelay,
            performMode = PerformMode.Forever(concept.interval)
        )
    }

    override suspend fun perform(concept: ForeverTimerConcept, performNumber: Int) {
        concept.onPerform(performNumber)
    }
}

/**
 * Input for [ForeverTimerAct].
 *
 * @property initialDelay The initial time to wait before first execution.
 * @property interval Time to wait on between each repetition.
 * @property onPerform Block of code to run on each execution.
 */
data class ForeverTimerConcept(
    val initialDelay: Duration,
    val interval: Duration,
    val onPerform: suspend (Int) -> Unit
) : ActConcept
