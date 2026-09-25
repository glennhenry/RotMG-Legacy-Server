package encore.route.guard

import encore.security.SimpleRateLimit
import encore.time.source.TimeSource
import io.ktor.http.HttpStatusCode
import io.ktor.server.application.ApplicationCall
import io.ktor.server.plugins.origin
import io.ktor.server.request.contentLength

/**
 * Default [SecurityGuard] implementation which performs basic request checks.
 *
 * - Rejects requests larger than 10 MB.
 * - Rejects requests from hosts listed in [bannedAddresses].
 * - Applies [SimpleRateLimit], limiting requests to 30 per 10-second window.
 */
class DefaultSecurity(private val bannedAddresses: Set<String>, timeSource: TimeSource) : SecurityGuard {
    private val rateLimiter = SimpleRateLimit(timeSource = timeSource)

    override suspend fun verify(call: ApplicationCall): GuardResult {
        verifyContentLength(call)?.let { return it }
        verifyRemoteHost(call)?.let { return it }
        verifyRequestFlood(call)?.let { return it }

        return GuardResult.Welcome
    }

    private fun verifyContentLength(call: ApplicationCall): GuardResult? {
        val length = call.request.contentLength() ?: return null

        if (length > 1024 * 1024 * 10) {
            return GuardResult.GetOut(HttpStatusCode.PayloadTooLarge, "payload too large", "payload too large")
        }

        return null
    }

    private fun verifyRemoteHost(call: ApplicationCall): GuardResult? {
        val remote = call.request.origin.remoteHost

        if (remote in bannedAddresses) {
            return GuardResult.GetOut(HttpStatusCode.Forbidden, "banned address", "banned address")
        }

        return null
    }

    private fun verifyRequestFlood(call: ApplicationCall): GuardResult? {
        val remote = call.request.origin.remoteHost

        if (!rateLimiter.allow(remote)) {
            return GuardResult.GetOut(HttpStatusCode.Forbidden, "rate limited", "rate limited")
        }

        return null
    }
}
