package encore.time

import encore.fancam.Fancam
import encore.fancam.Tags
import encore.time.source.SystemTimeSource
import encore.time.source.TimeController
import encore.time.source.TimeSource
import kotlin.math.max
import kotlin.time.Duration
import kotlin.time.Duration.Companion.minutes

/**
 * Central application component that provides time-related API.
 *
 * `TimeCenter` is a global component for consulting time and performing
 * time-based operations.
 *
 * Usage:
 * - Use [SystemTimeSource] by default, can be updated from [update].
 * - Retrieve the current system time with [now].
 * - Manipulates time from [TimeController] via [control].
 * - Provide time utilies that relies on a time source (e.g., [isBeforeNow], [isAfterNow]).
 *
 * Application components that relies on time may depend on [TimeSource]
 * (e.g., to replace [System.currentTimeMillis]).
 *
 *  @property source The underlying source responsible for producing time values
 *
 */
object TimeCenter {
    private var updated = false
    private var _source: TimeSource = SystemTimeSource()

    /**
     * Access point to the this time source manipulation behavior.
     */
    val control: TimeController = source.controller

    /**
     * Retrieve the underlying [TimeSource] installed on this [TimeCenter].
     */
    val source: TimeSource
        get() = _source

    /**
     * Update the underlying time source of [TimeCenter].
     */
    fun update(source: TimeSource) {
        if (updated) {
            Fancam.warn(Tags.Time) { "TimeCenter was already updated, ignoring." }
            return
        }
        this._source = source
        updated = true
    }

    /**
     * Returns the current time in epoch milliseconds according to this time [source].
     */
    fun now(): Long {
        return source.now()
    }

    /**
     * Returns `true` if more than [minutes] of minutes have elapsed
     * since [timestampMillis].
     * @param source optional [TimeSource] to override this local [source].
     */
    fun hasElapsedBy(
        timestampMillis: Long, duration: Duration,
        source: TimeSource = this.source
    ): Boolean {
        return source.now() > timestampMillis + duration.inWholeMilliseconds
    }

    /**
     * Returns the elapsed time since [timestampMillis].
     *
     * If [timestampMillis] is in the future, `0` is returned.
     * @param source optional [TimeSource] to override this local [source].
     */
    fun elapsedTimeSince(timestampMillis: Long, source: TimeSource = this.source): Long {
        return max(0, source.now() - timestampMillis)
    }

    /**
     * Returns the remaining time until [timestampMillis].
     *
     * If [timestampMillis] has already passed, `0` is returned.
     * @param source optional [TimeSource] to override this local [source].
     */
    fun remainingTime(timestampMillis: Long, source: TimeSource = this.source): Long {
        return max(0, timestampMillis - source.now())
    }

    /**
     * Returns whether [targetTime] is strictly before now.
     * @param source optional [TimeSource] to override this local [source].
     */
    fun isBeforeNow(targetTime: Long, source: TimeSource = this.source): Boolean {
        return source.now() > targetTime
    }

    /**
     * Returns whether [targetTime] is strictly after now.
     * @param source optional [TimeSource] to override this local [source].
     */
    fun isAfterNow(targetTime: Long, source: TimeSource = this.source): Boolean {
        return targetTime > source.now()
    }

    /**
     * Returns whether the [targetTime] is in the future.
     * *This is same as [isBeforeNow]*.
     * @param source optional [TimeSource] to override this local [source].
     */
    fun isPast(targetTime: Long, source: TimeSource = this.source): Boolean {
        return isBeforeNow(targetTime, source)
    }

    /**
     * Returns whether the [targetTime] is in the past.
     * *This is same as [isAfterNow]*.
     * @param source optional [TimeSource] to override this local [source].
     */
    fun isFuture(targetTime: Long, source: TimeSource = this.source): Boolean {
        return isAfterNow(targetTime, source)
    }

    /**
     * Returns whether the [targetTime] has not yet been reached.
     * *This is same as [isAfterNow]*.
     * @param source optional [TimeSource] to override this local [source].
     */
    fun hasNotReached(targetTime: Long, source: TimeSource = this.source): Boolean {
        return isAfterNow(targetTime, source)
    }
}
