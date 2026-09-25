package example

import encore.acts.*
import encore.acts.choreo.BasicChoreography
import encore.acts.choreo.Choreography
import encore.acts.choreo.PerformMode
import encore.acts.template.runTimer
import encore.fancam.Fancam
import encore.time.source.TimeSource
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.NonCancellable
import kotlinx.coroutines.test.advanceTimeBy
import kotlinx.coroutines.test.advanceUntilIdle
import kotlinx.coroutines.test.runTest
import kotlinx.coroutines.withContext
import testUtils.virtualTimeSource
import kotlin.test.*
import kotlin.time.Duration
import kotlin.time.Duration.Companion.milliseconds
import kotlin.time.Duration.Companion.minutes

class ExampleStageAct {
    /**
     * Simple example of testing a persistent act
     *  > Construct building for some amount of time
     *      > during onStart, progress is saved
     *  > Player disconnects, act is cancelled
     *  > Player reconnects, user check for saved progress manually
     *      > If there is progress saved, that means act is not finished and must be finished
     *      > Read progress, produce updated timing data
     *  > Resume act with the updated data
     *      > Turns out that the act is already finished whilst player is offline
     *      > Act will execute directly and finish the building construction
     */
    @OptIn(ExperimentalCoroutinesApi::class)
    @Test
    fun `example running building construction act`() = runTest {
        val pid = "playerABC"
        val bid = "outpost"

        val time = virtualTimeSource(this)
        val director = StageActDirector(time, ActIdStore)
        val repo = BuildingRepo()
        val scope = ActScope(pid, this)

        val id = director.run(
            act = BuildingConstructionAct(repo, time),
            concept = BuildingConstructionConcept(
                playerId = pid,
                buildingId = bid,
                buildDuration = 10.minutes,
                output = Fancam,
            ),
            scope = scope
        )

        // 3 minutes pass, player disconnects and act is stopped
        director.runTimer(3.minutes, scope) {
            assertTrue(director.stop(id))
            advanceUntilIdle()
            assertFalse(director.isRunning(id))

            // still unfinished
            assertNotNull(repo.unfinishedBuildings[bid])
            assertNull(repo.constructedBuildings.find { it == bid })
        }

        // 8 minutes after, player comebacks when act should be finished
        // time is continuous because building construction is supposed to be active
        advanceTimeBy(8.minutes)

        // this code reads progress and resume act according to that
        // in other scenario,
        // if nothing is saved, that means the building is already constructed
        val shouldFinishAt = repo.unfinishedBuildings[bid]!!
        val now = time.now()
        if (shouldFinishAt > now) {
            // if hasn't finished, reconstruct instance and re-run act with reduced time
            val remaining = shouldFinishAt - now
            // use runContinue to skip onStart
            director.runContinue(
                act = BuildingConstructionAct(repo, time),
                concept = BuildingConstructionConcept(
                    playerId = pid,
                    buildingId = bid,
                    buildDuration = remaining.minutes,
                    output = Fancam,
                ),
                scope = scope
            )
        } else {
            // has finished
            director.performAndContinue(
                act = BuildingConstructionAct(repo, time),
                concept = BuildingConstructionConcept(
                    playerId = pid,
                    buildingId = bid,
                    // this won't be used because act will finish immediately
                    buildDuration = 0.milliseconds,
                    output = Fancam,
                ),
                scope = scope
            )
            advanceUntilIdle()
            assertNull(repo.unfinishedBuildings[bid])
            assertNotNull(repo.constructedBuildings.find { it == bid })
        }
    }
}

// example of repository, assume this is a persistence component (DB)
class BuildingRepo {
    // buildingId -> finishAtTimestamp
    val unfinishedBuildings = mutableMapOf<String, Long>()
    val constructedBuildings = mutableListOf<String>()
}

class BuildingConstructionAct(
    private val repo: BuildingRepo,
    private val timeSource: TimeSource
) : StageAct<BuildingConstructionConcept> {
    override val enableLogging: Boolean = true

    override fun choreography(concept: BuildingConstructionConcept): Choreography<BuildingConstructionConcept> {
        // building construction only perform once when build duration finish
        return BasicChoreography(
            initialDelay = concept.buildDuration,
            performMode = PerformMode.Once
        )
    }

    // wrap important code with this to make it uninterruptable
    private suspend fun important(block: suspend () -> Unit) {
        withContext(NonCancellable) {
            block()
        }
    }

    override suspend fun onStart(concept: BuildingConstructionConcept) {
        // onStart notify player and save unfinished progress (to make resumpsion possible)
        concept.output.info {
            "Started building construction which " +
                    "will end in ${concept.buildDuration.inWholeMinutes} minutes."
        }

        important {
            val finishAtTimestamp = timeSource.now() + concept.buildDuration.inWholeMilliseconds
            repo.unfinishedBuildings[concept.buildingId] = finishAtTimestamp
        }
    }

    override suspend fun perform(concept: BuildingConstructionConcept, performNumber: Int) {
        if (performNumber > 1) {
            AssertionError("Shouldn't execute more than once.")
        }

        // wait time is done, build the building
        important {
            repo.constructedBuildings.add(concept.buildingId)
        }

        concept.output.info {
            "Building ${concept.buildingId} has finished construction."
        }
    }

    // onCancelled hook is not needed here since progress is already saved during onStart
    override suspend fun onCancelled(concept: BuildingConstructionConcept) = Unit

    override suspend fun onError(concept: BuildingConstructionConcept, cause: Exception) {
        // onError invalidates ongoing construction and notify failure
        important {
            repo.unfinishedBuildings.remove(concept.buildingId)
        }

        concept.output.info {
            "Building ${concept.buildingId} has finished construction."
        }
    }

    override suspend fun onEndingFairy(concept: BuildingConstructionConcept) {
        // onEndingFairy contains clean up code
        // it is invoked when act is finished
        important {
            repo.unfinishedBuildings.remove(concept.buildingId)
        }
    }
}

data class BuildingConstructionConcept(
    val playerId: String,
    val buildingId: String,
    val buildDuration: Duration,
    // this is like the player's connection to send game message
    val output: Fancam
) : ActConcept
