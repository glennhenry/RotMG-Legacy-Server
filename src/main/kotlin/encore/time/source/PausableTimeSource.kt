package encore.time.source

import io.ktor.util.date.getTimeMillis

/**
 * An implementation of [TimeSource] which is based on a real system time,
 * in addition to the support for pausing and resuming time.
 *
 * Implemented time control operation:
 * - [pause]
 * - [resume]
 */
class PausableTimeSource : TimeSource, TimeController {
    override val controller: TimeController = this

    private var pausedAt = getTimeMillis()
    private var resumedAt = getTimeMillis()
    private var paused = false

    override fun now(): Long {
        if (paused) {
            return pausedAt
        }
        return pausedAt + (getTimeMillis() - resumedAt)
    }

    override fun pause() {
        if (paused) return

        pausedAt = now()
        paused = true
    }

    override fun resume() {
        if (!paused) return

        resumedAt = getTimeMillis()
        paused = false
    }
}
