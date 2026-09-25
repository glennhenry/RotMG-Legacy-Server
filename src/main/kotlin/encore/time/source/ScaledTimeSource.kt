package encore.time.source

import io.ktor.util.date.getTimeMillis

/**
 * An implementation of [TimeSource] where the time returned from
 * [now] is scaled by some amount that can be modified from [setScale].
 *
 * Implemented time control operation:
 * - [setScale]
 */
class ScaledTimeSource : TimeSource, TimeController {
    override val controller: TimeController = this

    private var realMillis = getTimeMillis()
    private var anchorMillis = realMillis
    private var scale = 1.0

    override fun now(): Long {
        val realElapsedTime = getTimeMillis() - realMillis
        val scaledElapsedTime = (realElapsedTime * scale).toLong()
        return anchorMillis + scaledElapsedTime
    }

    override fun setScale(scale: Double) {
        anchorMillis = now()
        realMillis = getTimeMillis()
        this.scale = scale
    }
}
