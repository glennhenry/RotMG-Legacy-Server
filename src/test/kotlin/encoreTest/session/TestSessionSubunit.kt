package encoreTest.session

import encore.session.SessionSubunit
import encore.time.source.MutableTimeSource
import encore.time.source.SystemTimeSource
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.test.StandardTestDispatcher
import kotlinx.coroutines.test.TestScope
import kotlinx.coroutines.test.advanceTimeBy
import kotlinx.coroutines.test.runTest
import kotlin.test.Test
import kotlin.test.assertFalse
import kotlin.test.assertTrue
import kotlin.time.Duration.Companion.hours
import kotlin.time.Duration.Companion.minutes

class TestSessionSubunit {
    private fun scope(): CoroutineScope {
        return TestScope(StandardTestDispatcher())
    }

    @Test
    fun `test verify unknown token return false`() = runTest {
        val manager = SessionSubunit(scope(), SystemTimeSource())
        assertFalse(manager.verify("asdf"))
    }

    @Test
    fun `test verify unexpired session return true`() = runTest {
        val time = MutableTimeSource()
        val manager = SessionSubunit(scope(), time)
        val session = manager.create("pid123", validFor = 1.hours)
        assertTrue(manager.verify(session.token))

        // session max is 1 hr, should still be valid
        time.controller.forwardBy(45.minutes)
        assertTrue(manager.verify(session.token))
    }

    @Test
    fun `test verify expired session return false`() = runTest {
        val time = MutableTimeSource()
        val manager = SessionSubunit(scope(), time)
        val session = manager.create("pid123", validFor = 90.minutes)

        // session max is 1.5 hr, scope() is invalid because it must be refreshed first
        time.controller.forwardBy(2.hours)
        assertFalse(manager.verify(session.token))
    }

    @Test
    fun `test verify session lifetime exceeded the session duration but refreshed in between return true`() = runTest {
        val time = MutableTimeSource()
        val manager = SessionSubunit(scope(), time)
        val session = manager.create("pid123", validFor = 1.hours, lifetime = 6.hours)

        time.controller.forwardBy(40.minutes)
        manager.refresh(session.token)
        time.controller.forwardBy(40.minutes)
        assertTrue(manager.verify(session.token))
    }

    @OptIn(ExperimentalCoroutinesApi::class)
    @Test
    fun `test verify session refreshed after expired but before exceeding max lifetime return true`() = runTest {
        val time = MutableTimeSource()
        val manager = SessionSubunit(scope(), time)
        val session = manager.create("pid123")

        time.controller.forwardBy(2.hours)
        advanceTimeBy(2.hours)
        assertFalse(manager.verify(session.token))
        time.controller.forwardBy(2.hours)
        advanceTimeBy(2.hours)
        assertTrue(manager.refresh(session.token))
        assertTrue(manager.verify(session.token))
    }

    @OptIn(ExperimentalCoroutinesApi::class)
    @Test
    fun `test verify session refreshed after expired but after exceeding max lifetime return false`() = runTest {
        val time = MutableTimeSource()
        val manager = SessionSubunit(scope(), time)
        val session = manager.create("pid123", validFor = 1.hours, lifetime = 6.hours)

        time.controller.forwardBy(7.hours)
        advanceTimeBy(7.hours)
        assertFalse(manager.verify(session.token))
        assertFalse(manager.refresh(session.token))
        assertFalse(manager.verify(session.token))
    }
}
