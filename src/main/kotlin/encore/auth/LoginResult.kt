package encore.auth

import encore.session.UserSession
import encore.utils.types.Outcome

/**
 * Represents the result of a login attempt.
 *
 * This only contains business-level outcomes of authentication.
 * Internal/system errors (e.g., database failures) are not represented here
 * and should be handled separately (e.g., via [Outcome]).
 *
 * - [LoginResult.Success]: authentication succeeded.
 * - [LoginResult.InvalidCredentials]: authentication failed due to invalid credentials.
 * - [LoginResult.AccountNotFound]: no account exists for the given input.
 */
sealed interface LoginResult {
    /**
     * Represent a successful authentication.
     *
     * @property session the session for this login.
     */
    data class Success(val session: UserSession) : LoginResult

    /**
     * Auth failed due to wrong credentials (e.g., password).
     */
    data class InvalidCredentials(val message: String) : LoginResult

    /**
     * Auth failed due to inexistence of the account.
     */
    data class AccountNotFound(val message: String) : LoginResult
}
