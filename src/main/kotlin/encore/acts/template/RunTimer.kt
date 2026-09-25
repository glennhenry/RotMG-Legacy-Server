package encore.acts.template

import encore.acts.ActScope
import encore.acts.StageActDirector
import kotlin.time.Duration

/**
 * Shorthand API to run [TimerAct] which will execute after [duration].
 *
 * @param duration Time to wait before execution.
 * @param scope Runtime boundary of the timer.
 * @param block The block to execute.
 * @return A unique runtime identifier of the timer task.
 */
fun StageActDirector.runTimer(duration: Duration, scope: ActScope, block: suspend () -> Unit): String {
    return run(
        act = TimerAct(),
        concept = TimerConcept(duration) {
            block()
        },
        scope = scope
    )
}

/**
 * Shorthand API to run [RepeatingTimerAct] which will execute after [initialDelay],
 * repeats for [repetition], and waits for [interval] in between repetitions.
 *
 * @param initialDelay Time to wait before the first execution.
 * @param repetition The amount of repetition, not including the first execution.
 * @param interval Interval between each repetition.
 * @param scope Runtime boundary of the timer.
 * @param block The block to execute.
 * @return A unique runtime identifier of the timer task.
 */
fun StageActDirector.runRepeatingTimer(
    initialDelay: Duration, repetition: Int, interval: Duration,
    scope: ActScope,
    block: suspend (Int) -> Unit
): String {
    return run(
        act = RepeatingTimerAct(),
        concept = RepeatingTimerConcept(initialDelay, repetition, interval) {
            block(it)
        },
        scope = scope
    )
}

/**
 * Shorthand API to run [ForeverTimerAct] which will execute after [initialDelay],
 * repeats forever, and waits for [interval] in between repetitions.
 *
 * @param initialDelay Time to wait before the first execution.
 * @param interval Interval between each repetition.
 * @param scope Runtime boundary of the timer.
 * @param block The block to execute.
 * @return A unique runtime identifier of the timer task.
 */
fun StageActDirector.runForeverTimer(
    initialDelay: Duration, interval: Duration,
    scope: ActScope,
    block: suspend (Int) -> Unit
): String {
    return run(
        act = ForeverTimerAct(),
        concept = ForeverTimerConcept(initialDelay, interval) {
            block(it)
        },
        scope = scope
    )
}
