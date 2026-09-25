package encore.acts.template

import encore.acts.ActConcept
import encore.acts.StageAct
import encore.acts.choreo.BasicChoreography
import encore.acts.choreo.Choreography
import encore.acts.choreo.PerformMode
import kotlin.time.Duration

/**
 * A built-in stage act for simple timers.
 *
 * This will run only once after the given time from [TimerConcept.time].
 */
class TimerAct : StageAct<TimerConcept> {
    override val enableLogging: Boolean = false

    override fun choreography(concept: TimerConcept): Choreography<TimerConcept> {
        return BasicChoreography(
            initialDelay = concept.time,
            performMode = PerformMode.Once
        )
    }

    override suspend fun perform(concept: TimerConcept, performNumber: Int) {
        concept.onPerform(performNumber)
    }
}

/**
 * Input for [TimerAct].
 *
 * @property time The amount of time to wait before execution.
 * @property onPerform Block of code to run after waiting the amount of [time].
 */
data class TimerConcept(
    val time: Duration,
    val onPerform: suspend (Int) -> Unit
) : ActConcept
