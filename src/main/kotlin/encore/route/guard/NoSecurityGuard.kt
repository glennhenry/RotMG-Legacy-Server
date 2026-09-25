package encore.route.guard

import io.ktor.server.application.ApplicationCall

/**
 * [SecurityGuard] implementation that always allows the request.
 */
object NoSecurityGuard : SecurityGuard {
    override suspend fun verify(call: ApplicationCall): GuardResult {
        return GuardResult.Welcome
    }
}
