package testUtils

import encore.time.source.TimeController
import encore.time.source.TimeSource
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.test.TestScope

/**
 * A test-focused implementation of [TimeSource].
 *
 * The time here is based on the virtual time supplied by [TestScope].
 */
class VirtualTimeSource(private val scope: TestScope) : TimeSource, TimeController {
    override val controller: TimeController = this

    @OptIn(ExperimentalCoroutinesApi::class)
    override fun now(): Long = scope.testScheduler.currentTime
}

/**
 * Shorthand to create a [TimeSource] with [VirtualTimeSource].
 */
fun virtualTimeSource(scope: TestScope): TimeSource {
    return VirtualTimeSource(scope)
}
