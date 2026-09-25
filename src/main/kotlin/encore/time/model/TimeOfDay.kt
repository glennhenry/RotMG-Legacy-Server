package encore.time.model

import java.time.Instant
import java.time.ZoneId

/**
 * Represents a specific time of day using a 24-hour clock.
 *
 * Usage:
 * ```
 * TimeOfDay(23, 15)
 * 23.at(15)
 * ```
 *
 * @property hour The hour of the day (0-23).
 * @property minute The minute of the hour (0-59).
 * @throws IllegalArgumentException If [hour] or [minute] are outside their valid ranges.
 */
data class TimeOfDay(val hour: Int, val minute: Int) {
    init {
        require(hour in 0..23) { "Hour must be between 0 and 23" }
        require(minute in 0..59) { "Minute must be between 0 and 59" }
    }

    /**
     * Return string representation that looks like `[23:15]`.
     */
    override fun toString(): String {
        return "[$hour:$minute]"
    }
}

/**
 * Fluent API to describe [encore.time.model.TimeOfDay].
 */
fun Int.at(minute: Int): TimeOfDay {
    return TimeOfDay(this, minute)
}

/**
 * Computes the next wall-clock occurrence of this [TimeOfDay] relative to [now].
 *
 * For example, if `TimeOfDay` represents 15:00:
 * - If [now] is 14:00, this returns today at 15:00.
 * - If [now] is 16:00, this returns tomorrow at 15:00.
 * - If [now] is exactly 15:00 at second rate, this returns today at 15:00.
 *
 * The returned value is an absolute timestamp (epoch millis), not a delay.
 *
 * @param now the reference point in time (typically current time)
 * @param timezone the time zone used to interpret this [TimeOfDay]
 * @return epoch milliseconds of the next occurrence strictly after [now]
 */
fun TimeOfDay.nextOccurrence(now: Long, timezone: ZoneId): Long {
    val currentTime = Instant.ofEpochMilli(now).atZone(timezone)
    val targetTime = currentTime
        .withHour(hour)
        .withMinute(minute)
        .withSecond(0)
        .withNano(0)

    val next = if (!targetTime.isBefore(currentTime)) {
        targetTime
    } else {
        targetTime.plusDays(1)
    }

    return next.toInstant().toEpochMilli()
}
