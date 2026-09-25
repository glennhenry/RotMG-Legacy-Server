package encore.time.source

import io.ktor.util.date.getTimeMillis

/**
 * An implementation of [TimeSource] which is based on a real system time.
 * [now] returns the value of [getTimeMillis] directly.
 *
 * Implemented time control operation: N/A.
 */
class SystemTimeSource : TimeSource, TimeController {
    override val controller: TimeController = this

    override fun now(): Long {
        return getTimeMillis()
    }
}
