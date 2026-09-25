package encoreTest.time

import encore.time.TimeCenter
import encore.time.source.MutableTimeSource
import kotlin.test.Test
import kotlin.test.assertFalse
import kotlin.test.assertTrue
import kotlin.time.Duration.Companion.milliseconds
import kotlin.time.Duration.Companion.minutes
import kotlin.time.Duration.Companion.seconds

class TimeSourceTest {
    @Test
    fun `hasElapsedBy test`() {
        val timeSource = MutableTimeSource()
        TimeCenter.update(timeSource)

        val oldTime = timeSource.now()
        // assuming mutable time source is correct...
        timeSource.controller.forwardBy(2.minutes)
        assertTrue(TimeCenter.hasElapsedBy(oldTime, 1.minutes, timeSource))
        assertFalse(TimeCenter.hasElapsedBy(oldTime, 3.minutes, timeSource))
    }

    @Test
    fun `isBeforeNow test`() {
        val timeSource = MutableTimeSource()
        TimeCenter.update(timeSource)

        val now = timeSource.now()
        val behind = (now.milliseconds - 10.seconds).inWholeMilliseconds
        val after = (now.milliseconds + 10.seconds).inWholeMilliseconds
        assertTrue(TimeCenter.isBeforeNow(behind))
        assertFalse(TimeCenter.isBeforeNow(after))
    }

    @Test
    fun `isAfterNow test`() {
        val timeSource = MutableTimeSource()
        TimeCenter.update(timeSource)

        val now = timeSource.now()
        val behind = (now.milliseconds - 10.seconds).inWholeMilliseconds
        val after = (now.milliseconds + 10.seconds).inWholeMilliseconds
        assertFalse(TimeCenter.isAfterNow(behind))
        assertTrue(TimeCenter.isAfterNow(after))
    }
}
