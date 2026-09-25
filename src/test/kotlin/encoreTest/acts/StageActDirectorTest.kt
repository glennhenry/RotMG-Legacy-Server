package encoreTest.acts

import encore.acts.*
import encore.acts.choreo.BasicChoreography
import encore.acts.choreo.Choreography
import encore.acts.choreo.PerformMode
import encore.acts.template.*
import encore.fancam.Fancam
import encore.network.transport.DefaultConnection
import encore.time.source.SystemTimeSource
import io.ktor.utils.io.*
import io.ktor.utils.io.CancellationException
import io.ktor.utils.io.charsets.*
import kotlinx.coroutines.*
import kotlinx.coroutines.test.TestScope
import kotlinx.coroutines.test.advanceUntilIdle
import kotlinx.coroutines.test.currentTime
import kotlinx.coroutines.test.runTest
import kotlinx.io.Buffer
import kotlinx.io.Sink
import testUtils.TestFancam
import testUtils.virtualTimeSource
import kotlin.test.*
import kotlin.time.Duration
import kotlin.time.Duration.Companion.milliseconds
import kotlin.time.Duration.Companion.seconds

@OptIn(ExperimentalCoroutinesApi::class)
class StageActDirectorTest {
    @BeforeTest
    fun setup() {
        TestFancam.create()
    }

    @Test
    fun `act run once`() = runTest {
        runTimer(3.seconds, this)
    }

    @Test
    fun `multiple acts run once`() = runTest {
        // all these acts should start instantly since
        // director.run launches a coroutine and returns the act ID immediately

        // In real environment, there may be slight delay caused by
        // CPU, GC, coroutine, or setup creation

        // inside the coroutine, onStart is called, delay is started, perform is called,
        // and finally onEndingFairy is called
        runTimer(3.seconds, this)          // finish at tick 3s
        runTimer(3.seconds, this)          // finish at tick 3s
        runTimer(3.seconds, this)          // finish at tick 3s
        runTimer(2.seconds, this)          // finish at tick 2s
        runTimer(3500.milliseconds, this)  // finish at tick 3.5s
        runTimer(3001.milliseconds, this)  // finish at tick 3.001s
        runTimer(60.seconds, this)         // finish at tick 60s
    }

    @Test
    fun `multiple acts stopped when coroutine scope is cancelled`() = runTest {
        // when player disconnect, all their running tasks should be cancelled
        // since we have no data structure that stores every running tasks for a player
        // we just cancel their connection coroutine to automatically cancel them all
        // through structred concurrency.

        // simulates real connection
        // coroutine constructed like in GameStage
        val cor = CoroutineScope(SupervisorJob() + Dispatchers.Default)
        val connection = DefaultConnection(
            inputChannel = ByteReadChannel("", Charset.defaultCharset()),
            outputChannel = object: ByteWriteChannel {
                override fun cancel(cause: Throwable?) {}
                override suspend fun flush() {}
                override suspend fun flushAndClose() {}
                override val closedCause: Throwable = Throwable()
                override val isClosedForWrite: Boolean = false
                @InternalAPI override val writeBuffer: Sink = Buffer()
            },
            remoteAddress = "N/A",
            onSend = {},
            connectionScope = cor,
        )

        val scope = ActScope("TestScope", connection.connectionScope)
        val director = StageActDirector(virtualTimeSource(this), ActIdStore)

        // multiple acts running
        val id1 = director.runTimer(4.seconds, scope) {}
        val id2 = director.runTimer(5.seconds, scope) {}
        val id3 = director.runTimer(6.seconds, scope) {}
        val id4 = director.runTimer(7.seconds, scope) {}
        val id5 = director.runTimer(1.seconds, scope) {}

        assertTrue(director.isRunning(id1))
        assertTrue(director.isRunning(id2))
        assertTrue(director.isRunning(id3))
        assertTrue(director.isRunning(id4))
        assertTrue(director.isRunning(id5))

        // player disconnects and shutdown is called.
        // automatically cancels everything without calling StageActDirector.stop manually
        connection.shutdown()
        advanceUntilIdle()
        assertFalse(director.isRunning(id1))
        assertFalse(director.isRunning(id2))
        assertFalse(director.isRunning(id3))
        assertFalse(director.isRunning(id4))
        assertFalse(director.isRunning(id5))
        advanceUntilIdle()
    }

    private fun runTimer(time: Duration, scope: TestScope): String {
        val director = StageActDirector(virtualTimeSource(scope), ActIdStore)

        val id = director.run(
            act = TimerAct(),
            concept = TimerConcept(time) {
                Fancam.trace { "TestScope.currentTime=${scope.currentTime}" }
                assertEquals(scope.currentTime.milliseconds, time)
            },
            scope = ActScope("TestScope", scope)
        )

        Fancam.trace { "Timer started (will fire after ${time}ms)." }
        return id
    }

    @Test
    fun `isActive works as expected`() = runTest {
        val director = StageActDirector(virtualTimeSource(this), ActIdStore)

        val id = director.run(
            act = TimerAct(),
            concept = TimerConcept(3.seconds) {},
            scope = ActScope("TestScope", this)
        )

        // must be active after run is called
        val isActive = director.isRunning(id)
        assertTrue(isActive)
        Fancam.trace { "Timer started and isActive=${true}" }

        // assert that the act is no longer active after it finishes
        // runTest skips any delay and can't wait 3 seconds before this assertation
        // rely on another timer which finishes later to assert
        director.run(
            act = TimerAct(),
            concept = TimerConcept(3100.milliseconds) {
                val isActive = director.isRunning(id)
                assertFalse(isActive)
                Fancam.trace { "isActive=${false}" }
            },
            scope = ActScope("TestScope", this)
        )
    }

    @Test
    fun `act stop successfully stops it`() = runTest {
        val director = StageActDirector(virtualTimeSource(this), ActIdStore)

        val id = director.run(
            act = TimerAct(),
            concept = TimerConcept(3.seconds) {
                throw AssertionError("Executed here after 3 secs")
            },
            scope = ActScope("TestScope", this)
        )

        val isActive = director.isRunning(id)
        assertTrue(isActive)

        // stop and wait cancellation to finish
        assertTrue(director.stop(id))
        advanceUntilIdle()

        val isActive2 = director.isRunning(id)
        assertFalse(isActive2)
    }

    @Test
    fun `act throw error should stop it`() = runTest {
        val director = StageActDirector(virtualTimeSource(this), ActIdStore)

        // create the error act
        val id = director.run(
            act = TimerAct(),
            concept = TimerConcept(5.seconds) {
                throw RuntimeException("Exception inside perform")
            },
            scope = ActScope("TestScope", this)
        )

        // rely on another timer to assert
        // the error act should already throws before this
        director.run(
            act = TimerAct(),
            concept = TimerConcept(5001.milliseconds) {
                // assert the error act is no longer active
                // log should also have error message
                val isActive = director.isRunning(id)
                assertFalse(isActive)
                Fancam.trace { "isActive=${false}" }
            },
            scope = ActScope("TestScope", this)
        )
    }

    @Test
    fun `act run repeat`() = runTest {
        val director = StageActDirector(virtualTimeSource(this), ActIdStore)
        val initialDelay = 3.seconds
        val interval = 2.seconds

        director.run(
            act = RepeatingTimerAct(),
            concept = RepeatingTimerConcept(initialDelay, 5, interval) { performNumber ->
                Fancam.trace { "[run=$performNumber] TestScope.currentTime=${this.currentTime}" }
                assertEquals(
                    this.currentTime,
                    initialDelay.inWholeMilliseconds + (performNumber - 1) * interval.inWholeMilliseconds
                )
            },
            scope = ActScope("TestScope", this)
        )

        Fancam.trace { "Repeat timer started (will fire after ${initialDelay}ms, every ${interval}ms for 1 + 5 repeats)." }
    }

    @Test
    fun `act repeat stop successfully stops it`() = runTest {
        val director = StageActDirector(virtualTimeSource(this), ActIdStore)
        var performCount = 0

        val id = director.run(
            act = RepeatingTimerAct(),
            concept = RepeatingTimerConcept(500.milliseconds, 3, 500.milliseconds) { count ->
                Fancam.trace { "[run=$count] (${500 + (count - 1) * 500}ms)" }
                performCount += 1
            },
            scope = ActScope("TestScope", this)
        )

        // rely on another timer to stop the task at certain point
        director.run(
            act = TimerAct(),
            concept = TimerConcept(1700.milliseconds) {
                assertTrue(director.stop(id))
            },
            scope = ActScope("TestScope", this)
        )

        advanceUntilIdle()
        assertEquals(3, performCount)
    }

    @Test
    fun `act runs forever`() = runTest {
        val director = StageActDirector(virtualTimeSource(this), ActIdStore)
        var performCount = 0

        val interval = 2.seconds
        director.run(
            act = ForeverTimerAct(),
            concept = ForeverTimerConcept(Duration.ZERO, interval) { performNumber ->
                Fancam.trace { "[run=$performNumber] TestScope.currentTime=${this.currentTime}" }
                assertEquals(
                    this.currentTime,
                    0L + (performNumber - 1) * interval.inWholeMilliseconds
                )
                performCount += 1

                // stopping timer without director.stop by throwing CancellationException
                if (performNumber == 50) {
                    assertEquals(50, performCount)
                    throw CancellationException("Manual stop")
                }
            },
            scope = ActScope("TestScope", this)
        )

        Fancam.trace { "Forever timer started (will fire after 0ms, every ${interval.inWholeMilliseconds}ms)." }
    }

    @Test
    fun `act with slow onStart shouldn't drift execution`() = runTest {
        val director = StageActDirector(virtualTimeSource(this), ActIdStore)
        val scope = ActScope("TestScope", this)

        director.run(
            TimerWithOnStartAct(),
            TimerWithOnStartConcept(
                3.seconds,
                onStart = { delay(1.seconds) },
                onPerform = { assertEquals(this.currentTime, 3000L) }),
            scope
        )
    }

    @Test
    fun `act should be cancellable during non-perform lifecycle`() = runTest {
        val director = StageActDirector(virtualTimeSource(this), ActIdStore)
        val scope = ActScope("TestScope", this)

        // onStart very slow
        val id = director.run(
            TimerWithOnStartAct(),
            TimerWithOnStartConcept(
                delay = 3.seconds,
                onStart = { delay(5.seconds) },
                onPerform = { }),
            scope
        )

        // should start immediately and cancel the first act after one second.
        director.run(
            TimerWithOnStartAct(),
            TimerWithOnStartConcept(
                delay = 1.seconds,
                onStart = {},
                onPerform = {
                    assertTrue(director.stop(id))
                    advanceUntilIdle()
                    assertFalse(director.isRunning(id))
                }),
            scope
        )
    }

    @Test
    fun `director should unbind actId after task is stopped`() = runTest {
        val store = ActIdStore
        val director = StageActDirector(SystemTimeSource(), store)
        val scope = ActScope("TestScope", this)

        val id = director.run(
            TimerAct(),
            TimerConcept(
                time = 3.seconds,
                onPerform = { }),
            scope
        )
        store.bind(id, "hello123")

        director.run(
            TimerAct(),
            TimerConcept(
                time = 1.seconds,
                onPerform = {
                    // should be same for finish or error since we use finally block
                    assertNotNull(store.find("hello123"))
                    assertTrue(director.stop(id))
                    advanceUntilIdle()
                    assertFalse(director.isRunning(id))
                    assertNull(store.find("hello123"))
                }),
            scope
        )
    }

    @Test
    fun `runContinue skips onStart`() = runTest {
        val director = StageActDirector(virtualTimeSource(this), ActIdStore)
        val scope = ActScope("TestScope", this)

        director.runContinue(
            TimerWithOnStartAct(),
            TimerWithOnStartConcept(
                delay = 1.seconds,
                onStart = { throw AssertionError("onStart was executed") },
                onPerform = { }),
            scope
        )
    }

    @Test
    fun `executeAndContinue skips onStart and executes directly`() = runTest {
        val director = StageActDirector(virtualTimeSource(this), ActIdStore)
        val scope = ActScope("TestScope", this)

        director.performAndContinue(
            TimerWithOnStartAct(),
            TimerWithOnStartConcept(
                delay = 1.seconds,
                onStart = { throw AssertionError("onStart was executed") },
                onPerform = { assertEquals(0, currentTime) }),
            scope
        )
    }

    @Test
    fun `executeAndContinue skips onStart, executes directly, and continue normal flow`() = runTest {
        val director = StageActDirector(virtualTimeSource(this), ActIdStore)
        val scope = ActScope("TestScope", this)

        director.performAndContinue(
            RepeatTimerWithOnStartAct(),
            RepeatTimerWithOnStartConcept(
                initialDelay = 1.seconds,
                repeat = 3,
                interval = 1.seconds,
                onStart = { throw AssertionError("onStart was executed") },
                onPerform = { count ->
                    // with executeAndContinue,
                    // run would be 0, 1, 2, 3
                    // instead of 1, 2, 3, 4
                    assertEquals(1000L * (count - 1), currentTime)
                }),
            scope
        )
    }
}

class TimerWithOnStartAct : StageAct<TimerWithOnStartConcept> {
    override val enableLogging: Boolean = false

    override suspend fun onStart(concept: TimerWithOnStartConcept) {
        concept.onStart()
    }

    override fun choreography(concept: TimerWithOnStartConcept): Choreography<TimerWithOnStartConcept> {
        return BasicChoreography(
            initialDelay = concept.delay,
            performMode = PerformMode.Once
        )
    }

    override suspend fun perform(concept: TimerWithOnStartConcept, performNumber: Int) {
        concept.onPerform(performNumber)
    }
}

data class TimerWithOnStartConcept(
    val delay: Duration,
    val onStart: suspend () -> Unit,
    val onPerform: suspend (Int) -> Unit
) : ActConcept

class RepeatTimerWithOnStartAct : StageAct<RepeatTimerWithOnStartConcept> {
    override val enableLogging: Boolean = false

    override suspend fun onStart(concept: RepeatTimerWithOnStartConcept) {
        concept.onStart()
    }

    override fun choreography(concept: RepeatTimerWithOnStartConcept): Choreography<RepeatTimerWithOnStartConcept> {
        return BasicChoreography(
            initialDelay = concept.initialDelay,
            performMode = PerformMode.Repeat(concept.repeat, concept.interval)
        )
    }

    override suspend fun perform(concept: RepeatTimerWithOnStartConcept, performNumber: Int) {
        concept.onPerform(performNumber)
    }
}

data class RepeatTimerWithOnStartConcept(
    val initialDelay: Duration,
    val repeat: Int,
    val interval: Duration,
    val onStart: suspend () -> Unit,
    val onPerform: suspend (Int) -> Unit
) : ActConcept
