package encore.route.guard

import io.ktor.server.application.ApplicationCall

/**
 * Authentication mechanism executed before request handling.
 *
 * Implementations inspect the [ApplicationCall] in [verify] to determine
 * whether the request may proceed. Request processing continues only when
 * [GuardResult.Welcome] is returned, while a [GuardResult.GetOut] immediately
 * aborts request handling.
 *
 * Typical use-cases:
 * - Validating cookies or session tokens.
 * - Verifying login state or account identity in server
 *   based on the available information in the request.
 *
 * This should not handle low-level security mitigation or request validation.
 *
 * Can use [NoAuthGuard] to skip this check.
 */
interface AuthGuard {
    /**
     * Verifies the request and returns a [GuardResult].
     *
     * If [GuardResult.GetOut] is returned, request handling stops
     * immediately without reaching to the route handler.
     *
     * Implementations are responsible for sending any authentication or
     * authorization failure response (e.g., via `call.respond(...)`)
     * before returning [GuardResult.GetOut], as no later component will be
     * able to do so.
     */
    suspend fun verify(call: ApplicationCall): GuardResult
}
