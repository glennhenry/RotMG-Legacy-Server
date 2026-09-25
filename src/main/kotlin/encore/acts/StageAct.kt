package encore.acts

import encore.acts.choreo.BasicChoreography
import encore.acts.choreo.Choreography
import encore.acts.choreo.PerformMode

/**
 * Represents a scheduled server-side task.
 *
 * A `StageAct` is a deferred execution bound to a runtime owner (e.g., a player or the server)
 * with a defined lifecycle. It takes an [ActConcept] as input for execution.
 *
 * Stage acts are typically used for time-based or repeated operations. For example,
 * a building construction that completes after 5 minutes can be modeled as a `StageAct`
 * with a 5 minutes delay, and will notify player of its completion inside [perform].
 *
 * Stage acts can be run via [StageActDirector].
 *
 * #### Scheduling
 *
 * The execution behavior is defined by [choreography] that produces a [Choreography]
 * instance. For example, implementation may return a [BasicChoreography] that will
 * define the execution schedule based on `initialDelay` and [PerformMode].
 *
 * #### Lifecycle
 *
 * The stage act system offers 4 lifecycles:
 * - [onStart]: Invoked once when the act is first scheduled to run.
 * - [perform]: The main execution step. Invoked once or repeatedly depending on [Choreography].
 * - [onEndingFairy]: Invoked once when the act completes all scheduled executions.
 *                    For acts that runs forever, this will never be called.
 *                    Stop or cancellation will instead call the [onCancelled].
 * - [onCancelled]: Invoked if the act is stopped before normal completion.
 * - [onError]: Invoked when error was thrown throughout act lifecycle
 *              which includes `onStart`, `perform`, `onEndingFairy`, or inside
 *              logic like [Choreography.next].
 *
 * @param T The type of [ActConcept] for this stage act.
 */
interface StageAct<T : ActConcept> {
    /**
     * Whether to log scheduling details which is invoked before each performs.
     * This can potentially be noisy for acts with short delays.
     *
     * Example logs:
     * ```
     * Act 'TimerWithOnStartAct' next perform in (0d 0hr 0m 1s / at 21:34:25) for 'TestScope' (actId=0616a51e-b164-42a8-baa9-fb8020300cda)
     * Act 'TimerWithOnStartAct' will perform directly for 'TestScope' (actId=69b19aff-e735-4dcd-832e-3d1f80c547d8)
     * ```
     */
    val enableLogging: Boolean

    /**
     * Produces the choreography for this act.
     */
    fun choreography(concept: T): Choreography<T>

    /**
     * Called once when the act is first scheduled.
     * Use for initialization such as:
     * - notify client
     * - persisting initial progress data
     */
    suspend fun onStart(concept: T) = Unit

    /**
     * Main execution body of the act.
     *
     * ###### performNumber
     *
     * Indicates the current perform number (1-based).
     *
     * For example,
     * ```
     * 3 repetitions
     * performNumber = 1 | initialRun
     * performNumber = 2 | repeat 1
     * performNumber = 3 | repeat 2
     * performNumber = 4 | repeat 3
     * ```
     *
     * This value is always `1` for [PerformMode.Once].
     *
     * @param performNumber Current perform number (1-based).
     */
    suspend fun perform(concept: T, performNumber: Int)

    /**
     * Called once when the act completes all scheduled executions successfully.
     * Use for closing or clean up such as:
     * - notify client
     * - deleting persistent progress data
     */
    suspend fun onEndingFairy(concept: T) = Unit

    /**
     * Called if the act is cancelled before completing normally.
     * Use for progress save or rollback such as:
     * - notify client
     * - invalidating unfinished result
     * - saving current progress data
     */
    suspend fun onCancelled(concept: T) = Unit

    /**
     * Called when an exception was thrown during any of the lifecycles
     * except [onCancelled] and [onError] itself. Exceptions thrown from
     * [onCancelled] and [onError] itself are safely caught and logged.
     *
     * Use for clean up or rollback such as:
     * - notify client
     * - marking state as invalid
     * - deleting persisted data
     *
     * @param cause The cause of error.
     */
    suspend fun onError(concept: T, cause: Exception) = Unit
}
