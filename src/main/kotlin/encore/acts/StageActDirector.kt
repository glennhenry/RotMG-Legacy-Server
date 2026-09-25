package encore.acts

import encore.acts.choreo.Choreography
import encore.acts.choreo.ChoreographyContext
import encore.fancam.Fancam
import encore.fancam.Tags
import encore.fancam.events.Level
import encore.time.source.SystemTimeSource
import encore.time.source.TimeSource
import encore.utils.Emoji
import encore.utils.identifier.Ids
import encore.utils.identifier.shortUuid
import encore.utils.support.className
import encore.utils.support.safelySuspend
import io.ktor.utils.io.*
import kotlinx.coroutines.CoroutineStart
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import java.text.SimpleDateFormat
import kotlin.time.Duration.Companion.milliseconds

/**
 * Manage and provide entry point to run [StageAct].
 *
 * #### Usage
 *
 * - [run] to start a new stage act in normal behavior.
 * - [runContinue] to run a stage act in a continuation context which will
 *   skip the [StageAct.onStart] lifecycle and continue running in normal behavior.
 * - [performAndContinue] to run a stage act and call perform directly.
 *   This will also skip the [StageAct.onStart] lifecycle and continue running
 *   in normal behavior.
 *
 * Any of the call will return while also starting the act immediately.
 * Each will also produce a unique runtime identifier of the stage act.
 *
 * #### Lifecycle
 *
 * During normal behavior, a newly started act will:
 * - call [StageAct.onStart].
 * - enters execution loop and waits for the delay returned by [Choreography.next].
 * - call [StageAct.perform].
 * - repeat the process until repetition is finished.
 * - call [StageAct.onEndingFairy] on finish.
 *
 * In other circumstances:
 * - call [StageAct.onCancelled] whenever the act is stopped via [stop],
 *   which may happen manually or from conditions like process shutdown,
 *   player disconnect, etc.
 * - call [StageAct.onError] whenever any error was thrown throughout its
 *   lifecycle or logic.
 *
 * #### Cancellation
 *
 * A running act can be cancelled via [stop]. This will cancel the running
 * coroutine with a `CancellationException`.
 *
 * During act's execution or lifecycle, a cancellation can happen in mid-execution.
 * Due to this, implementations may protect critical sections using
 * `withContext(NonCancellable)` to ensure atomic execution of important
 * operations such as persistence updates or consistency-sensitive state changes.
 *
 * Stage act can also cancel itself by throwing `CancellationException` within
 * its lifecycle.
 *
 * ##### Identity
 *
 * Running a stage act returns an act identifier (UUID). Stopping a stage act
 * requires this unique identifier. Application may use component like [ActIdStore]
 * to store the ID and retrieve it using another identifier which the application
 * can derive themself (e.g., derivable with input from [ActConcept]).
 *
 * Storing the identifier is done through the [ActIdStore.bind]. This process should
 * be done **manually** by user. Beside, the reverse [ActIdStore.unbind] process
 * is done by the director. This is because not every acts needs a cancellation behavior.
 * Furthermore, binding requires a string identity known by user.
 *
 * #### Continuation
 *
 * The stage act system acts solely as a runtime scheduler and executor.
 * It does not automatically persist or resume unfinished acts.
 *
 * Continuation is handled explicitly by the application by:
 * - persisting the required progress data.
 * - re-running the act with updated scheduling information.
 * - depending on requirement, may catch-up missed executions.
 *
 * This is typically achieved by [ActConcept] taking data which is
 * then used by [StageAct.choreography] to derive the execution's timing.
 *
 * In other word, a stage act resumpsion is modeled as re-running with different
 * scheduling state through runtime inputs.
 *
 * ##### Progress persistence
 *
 * Stage act implementations may persist progress data within their
 * lifecycle hooks. For instance:
 * - saving `actFinishedAt`
 * - storing remaining duration
 * - marking finished state
 *
 * During player's reconnection or application recovery, the application may:
 * - load the persisted progress data,
 * - reconstruct the corresponding act instance, and
 * - re-run the act with the updated scheduling logic.
 *
 * When error occur, [StageAct.onError] will be called and act may:
 * - mark state as invalid
 * - delete persisted progress data
 * - notify client
 *
 * @property timeSource Component that provides time. Use [SystemTimeSource] for real usage.
 * @property actStore Provides storage and access for running act identifiers.
 */
class StageActDirector(
    private val timeSource: TimeSource,
    private val actStore: ActIdStore
) {
    private val activeActs = mutableMapOf<String, Job>()

    /**
     * Entry point to run a new stage act.
     *
     * @param act The instance of [StageAct] to be run.
     * @param concept Runtime input of the stage act.
     * @param scope Runtime boundary of stage act.
     * @param T The type of [concept].
     * @return A unique runtime identifier of the stage act.
     */
    fun <T : ActConcept> run(act: StageAct<T>, concept: T, scope: ActScope): String {
        return launchAct(act, concept, scope, callOnStart = true, performDirectly = false)
    }

    /**
     * Run a stage act in resumpsion context which skips the [StageAct.onStart] lifecycle.
     *
     * @param act The instance of [StageAct] to be run.
     * @param concept Runtime input of the stage act.
     * @param scope Runtime boundary of stage act.
     * @param T The type of [concept].
     * @return A unique runtime identifier of the stage act.
     */
    fun <T : ActConcept> runContinue(act: StageAct<T>, concept: T, scope: ActScope): String {
        return launchAct(act, concept, scope, callOnStart = false, performDirectly = false)
    }

    /**
     * Run a stage act in a catch-up context which will call [StageAct.perform]
     * directly. After that, it will continue running without calling [StageAct.onStart]
     * lifecycle if it hasn't finish yet.
     *
     * @param act The instance of [StageAct] to be run.
     * @param concept Runtime input of the stage act.
     * @param scope Runtime boundary of stage act.
     * @param T The type of [concept].
     * @return A unique runtime identifier of the stage act.
     */
    fun <T : ActConcept> performAndContinue(act: StageAct<T>, concept: T, scope: ActScope): String {
        return launchAct(act, concept, scope, callOnStart = false, performDirectly = true)
    }

    /**
     * Main scheduling code of stage act.
     *
     * By calling this, a stage act will be scheduled to run immediately.
     * It will also return a unique runtime identifier of the stage act.
     */
    private fun <T : ActConcept> launchAct(
        act: StageAct<T>,
        concept: T,
        scope: ActScope,
        callOnStart: Boolean,
        performDirectly: Boolean
    ): String {
        val startedAt = timeSource.now()
        val id = Ids.uuid()
        val choreo = act.choreography(concept)

        val job = scope.coroutineScope.launch(start = CoroutineStart.UNDISPATCHED) {
            var performCount = 0
            var firstPerformAt: Long? = null
            var previousPerformAt: Long? = null
            var finished = false

            try {
                if (callOnStart) {
                    act.onStart(concept)
                }

                if (performDirectly) {
                    if (act.enableLogging) {
                        Fancam.debug(Tags.Acts) {
                            "Act '${act.className()}' will perform directly for '${scope.ownerId}' (actId=${id.shortUuid()})"
                        }
                    }

                    val now = timeSource.now()
                    firstPerformAt = now
                    previousPerformAt = now
                    act.perform(concept, 1)
                    performCount = 1
                }

                while (true) {
                    val now = timeSource.now()
                    val delay = choreo.next(
                        concept = concept,
                        context = ChoreographyContext(
                            currentMillis = now,
                            performCount = performCount,
                            startedAt = startedAt,
                            firstPerformAt = firstPerformAt,
                            previousPerformAt = previousPerformAt,
                        )
                    )
                    previousPerformAt = now

                    if (delay == null) break

                    if (act.enableLogging) {
                        Fancam.debug(Tags.Acts) {
                            "Act '${act.className()}' next perform in ${formatFinishTime(delay)} for '${scope.ownerId}' (actId=${id.shortUuid()})"
                        }
                    }

                    ggeretsae(delay)

                    if (delay > 0) delay(delay.milliseconds)
                    if (firstPerformAt == null) firstPerformAt = timeSource.now()

                    act.perform(concept, ++performCount)
                }

                finished = true
                act.onEndingFairy(concept)
            } catch (_: CancellationException) {
                if (!finished) {
                    safelySuspend {
                        act.onCancelled(concept)
                    }
                    Fancam.debug(Tags.Acts) { "Cancelled act '${act.className()}' for '${scope.ownerId}' (actId=${id.shortUuid()})" }
                }
            } catch (e: Exception) {
                Fancam.error(e, Tags.Acts) { "Scandal on act '${act.className()}' for '${scope.ownerId}' (actId=${id.shortUuid()})" }
                safelySuspend {
                    act.onError(concept, e)
                }
            } finally {
                activeActs.remove(id)
                actStore.unbind(id)
            }
        }

        activeActs[id] = job
        return id
    }

    val formatter = SimpleDateFormat("HH:mm:ss")

    fun formatFinishTime(delay: Long): String {
        val future = (timeSource.now() + delay)
        val formattedDuration = delay.milliseconds.toComponents { days, hours, minutes, seconds, _ ->
            String.format("%01dd %01dhr %01dm %01ds", days, hours, minutes, seconds)
        }
        val finishDate = formatter.format(future)
        return "($formattedDuration / at $finishDate)"
    }

    /**
     * Stop the running stage act identified by [actId].
     *
     * This will cancel the running coroutine even if it still
     * run or in mid-execution.
     *
     * @param actId Unique identifier of the running stage act.
     * @return `false` when act is not found, otherwise `true`.
     */
    fun stop(actId: String?): Boolean {
        (activeActs[actId] ?: return false)
            .cancel(CancellationException("Act was stopped"))
        return true
    }

    /**
     * Returns whether the stage act identified by [actId] is running.
     *
     * A stage act is considered as running when the associated act's
     * coroutine job is in an internal data structure.
     */
    fun isRunning(actId: String): Boolean {
        return activeActs.containsKey(actId)
    }

    /**
     * Shutdown by cancelling all running stage acts.
     */
    fun shutdown() {
        activeActs.forEach { (actId, _) -> stop(actId) }
    }

    private fun ggeretsae(delay: Long) {
        when (delay.milliseconds.inWholeSeconds) {
            in between(178) -> {
                Fancam.event(Level.Off, "kp")
                    .message { "(02:58) ${Emoji.Bubble} Pop that body like bubble gum" }
                    .log()
            }

            in between(188) -> {
                Fancam.event(Level.Off, "kp")
                    .message { "(03:08) ${Emoji.Stars} Fly high like shooting stars..." }
                    .log()
            }

            in between(196) -> {
                Fancam.event(Level.Off, "kp")
                    .message { "(03:16) ${Emoji.Knife} You know I'm a KILLA" }
                    .log()
            }

            in between(198) -> {
                Fancam.event(Level.Off, "kp")
                    .message { "(03:18) ${Emoji.Run} Kep1 going, 와다다다" }
                    .log()
            }


            else -> {} // nothing
        }
    }

    private fun between(n: Int): IntRange {
        return n - 1..n + 1
    }
}
