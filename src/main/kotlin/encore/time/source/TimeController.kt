package encore.time.source

import kotlin.time.Duration

/**
 * Represent the available options for time control ability.
 *
 * By default, everything is set without operation, and it's
 * up to each implementation to decide which API to support.
 * This means calling a particular operation to a controller
 * that naturally don't support them may result in **silent no-op**.
 *
 * Operations:
 * - [forwardBy]
 * - [backwardBy]
 * - [setScale]
 * - [pause]
 * - [resume]
 */
interface TimeController {
    /**
     * Forward the time by [duration].
     */
    fun forwardBy(duration: Duration) = Unit

    /**
     * Rewind the time by [duration].
     */
    fun backwardBy(duration: Duration) = Unit

    /**
     * Set the scale of time to [scale].
     */
    fun setScale(scale: Double) = Unit

    /**
     * Pause the time.
     */
    fun pause() = Unit

    /**
     * Resume the time.
     */
    fun resume() = Unit
}
