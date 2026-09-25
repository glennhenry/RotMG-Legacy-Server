package encore.time.source

import io.ktor.util.date.getTimeMillis
import kotlin.time.Duration

/**
 * An implementation of [TimeSource] which allows the mutation of time
 * returned from [now]. This can be done from [forwardBy] and [backwardBy].
 *
 * Implemented time control operation:
 * - [forwardBy]
 * - [backwardBy]
 */
class MutableTimeSource : TimeSource, TimeController {
    override val controller: TimeController = this
    private var offsetMillis = 0L

    override fun now(): Long {
        return getTimeMillis() + offsetMillis
    }

    /**
     * Increase time by [duration].
     * This will results in [now] being ahead of the real system time.
     */
    override fun forwardBy(duration: Duration) {
        offsetMillis += duration.inWholeMilliseconds
    }

    /**
     * Decrease time by [duration].
     * This will results in [now] being behind of the real system time.
     */
    override fun backwardBy(duration: Duration) {
        offsetMillis -= duration.inWholeMilliseconds
    }
}
