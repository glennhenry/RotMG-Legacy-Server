package encore.acts.choreo

import encore.acts.ActConcept
import encore.acts.StageAct
import kotlin.time.Duration

/**
 * Basic scheduling implementation for a [StageAct].
 *
 * This model is suitable for simple tasks that:
 * - start after a fixed delay, and
 * - optionally repeat with a fixed interval.
 *
 * @property initialDelay The delay before the first performs.
 * @property performMode Defines the act performs portion.
 */
data class BasicChoreography<T : ActConcept>(
    val initialDelay: Duration, val performMode: PerformMode
) : Choreography<T> {
    override fun next(concept: T, context: ChoreographyContext): Long? {
        if (isFinished(context.performCount + 1)) {
            return null
        }

        val firstPerformAt = context.firstPerformAt ?: (context.startedAt + initialDelay.inWholeMilliseconds)
        return delayLeft(firstPerformAt, context.currentMillis, context.performCount)
    }

    private fun delayLeft(
        firstPerformAt: Long,
        currentMillis: Long,
        performCount: Int
    ): Long {
        return when (performMode) {
            is PerformMode.Once -> {
                calculateDelay(firstPerformAt, currentMillis, performCount, Duration.ZERO)
            }

            is PerformMode.Repeat -> {
                calculateDelay(firstPerformAt, currentMillis, performCount, performMode.interval)
            }

            is PerformMode.Forever -> {
                calculateDelay(firstPerformAt, currentMillis, performCount, performMode.interval)
            }
        }
    }

    private fun calculateDelay(firstPerformAt: Long, currentMillis: Long, performCount: Int, interval: Duration): Long {
        val nextPerformAt = firstPerformAt + performCount * (interval.inWholeMilliseconds)
        val timeLeftUntilNextPerform = nextPerformAt - currentMillis
        return timeLeftUntilNextPerform
    }

    private fun isFinished(newPerformCount: Int): Boolean {
        return when (performMode) {
            is PerformMode.Once -> newPerformCount > 1
            is PerformMode.Repeat -> {
                newPerformCount > performMode.repetition + 1
            }

            is PerformMode.Forever -> false
        }
    }
}
