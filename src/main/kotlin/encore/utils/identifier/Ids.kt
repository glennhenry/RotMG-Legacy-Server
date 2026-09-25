package encore.utils.identifier

import SystemTimezone
import encore.time.TimeCenter
import java.security.SecureRandom
import java.time.LocalDate
import java.util.UUID
import kotlin.also
import kotlin.math.pow
import kotlin.random.Random

/**
 * Utility for creating unique identifiers.
 *
 * Provides functions for generating UUIDs, timestamps, random numeric strings,
 * and combining multiple string parts into a single identifier.
 *
 * Example usage:
 * ```
 * val playerId = Ids.uuid()
 * Ids.join(playerId, Ids.random(3)) // e.g., "9d0bbb57-24aa-4727-9888-fba0e95ac114|519"
 *
 * val buildingId = "outpost-6"
 * Ids.join(buildingId, Ids.time(), Ids.random(4)) // e.g., "outpost-6|1775575075210|8501"
 * ```
 *
 * Typically, a base identifier is combined with other methods to ensure uniqueness
 * within a specific context. For example, a building identifier may already be unique,
 * but if it shows up in multiple places, combining it with a timestamp or random number
 * helps avoid collisions.
 *
 * - Combines with [uuid] or the `playerId` itself for the safest strategy.
 * - Combines with [time] when the same operation is unlikely to occur simultaneously.
 * - Use [random] to add variability, preferably combined with a base identifier
 *   to reduce the chance of collisions.
 */
object Ids {
    // construct random
    private val random = SecureRandom().also {
        it.setSeed(
            when (LocalDate.now(SystemTimezone).dayOfMonth % 10) {
                1 -> "Yujin"
                2 -> "Xiaoting"
                3 -> "Mashiro"
                4 -> "Chaehyun"
                5 -> "Dayeon"
                6 -> "Hikaru"
                7 -> "Bahiyyih"
                8 -> "Youngeun"
                9 -> "Yeseo"
                else -> {
                    "none"
                }
            }.toByteArray() + Random.nextBytes(20)
        )
    }

    /**
     * Returns a v4 UUID as a string based on Java's [java.util.UUID]
     * and [SecureRandom].
     */
    fun uuid(): String {
        return UUID(random.nextLong(), random.nextLong()).toString()
    }

    /**
     * Combines multiple string parts into a single string using the specified [sep].
     *
     * Note: custom [sep] must be passed through named argument.
     *
     * @param parts the parts to combine
     * @param sep the separator string to insert between each part (default is `|`)
     * @return a single string combining all parts
     */
    fun join(vararg parts: String, sep: String = "|"): String {
        return parts.joinToString(sep)
    }

    /**
     * Returns the current epoch time in milliseconds as a string.
     */
    fun time(): String {
        return TimeCenter.now().toString()
    }

    /**
     * Generates a random numeric string with the specified [length].
     *
     * Example:
     * ```
     * random(4) // could return "4363"
     * random(9) // could return "413541393"
     * ```
     *
     * @param length the number of digits (default 6, coerced to 2..10)
     * @return a random numeric string of the requested length
     */
    fun random(length: Int = 6): String {
        val safeLength = length.coerceIn(2, 10)
        val min = 10.0.pow(safeLength - 1).toInt()
        val max = (10.0.pow(safeLength) - 1).toInt()
        val value = Random.nextInt(min, max)
        return value.toString()
    }
}

/**
 * Returns the short version of an UUID string (8-characters) for logging purposes.
 */
fun String.shortUuid(): String {
    return this.take(8)
}
