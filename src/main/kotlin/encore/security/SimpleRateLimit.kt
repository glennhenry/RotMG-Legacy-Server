package encore.security

import encore.time.source.TimeSource
import kotlin.time.Duration.Companion.seconds

/**
 * Minimal in-memory implementation of rate limiter system.
 *
 * Requests are limited to [maxRequests] per [timeWindow] based on the
 * remote host address. This defaults to 30 requests per 10-second.
 *
 * This implementation is intentionally simple and intended to introduce an example.
 *
 * @property timeWindow Duration of time in millis to when the request's limit expires.
 * @property maxRequests The maximum amount of request within [timeWindow].
 */
class SimpleRateLimit(
    private val timeWindow: Long = 10.seconds.inWholeMilliseconds,
    private val maxRequests: Int = 500,
    private val timeSource: TimeSource
) {
    private data class Entry(var count: Int, var expiresAt: Long)

    private val entries = mutableMapOf<String, Entry>()

    /**
     * Returns whether the request represented by [remoteHost] is allowed.
     * Returning `false` indicates the request has been rate limited.
     */
    fun allow(remoteHost: String): Boolean {
        val now = timeSource.now()

        val entry = entries.getOrPut(remoteHost) {
            Entry(count = 0, expiresAt = now + timeWindow)
        }

        if (now >= entry.expiresAt) {
            entry.count = 0
            entry.expiresAt = now + timeWindow
        }

        entry.count++

        return entry.count <= maxRequests
    }
}
