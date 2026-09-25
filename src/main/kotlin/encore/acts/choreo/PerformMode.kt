package encore.acts.choreo

import encore.acts.StageAct
import kotlin.time.Duration

/**
 * Describes a [StageAct] performs portion.
 *
 * - [Once]
 * - [Repeat]
 * - [Forever]
 */
sealed class PerformMode {
    /**
     * The stage act is performed exactly once.
     */
    data object Once : PerformMode()

    /**
     * The stage act is performed repeatedly with a fixed interval.
     *
     * The total number of executions is `repetition + 1`, as [repetition] counts only
     * the additional repeats after the initial execution.
     *
     * Examples:
     * - `repetition = 0` is equivalent to [Once]
     * - `repetition = 1` is executed twice in total
     *
     * @property repetition Number of additional executions after the first run.
     * @property interval Interval between executions, in [Duration].
     */
    data class Repeat(val repetition: Int, val interval: Duration) : PerformMode()

    /**
     * The stage act is performed indefinitely at a fixed interval.
     *
     * @property interval Interval between executions, in [Duration].
     */
    data class Forever(val interval: Duration) : PerformMode()
}
