package encore.auth

import com.mongodb.MongoWriteException
import com.toxicbakery.bcrypt.Bcrypt
import encore.EncoreConfig
import encore.account.AccountSubunit
import encore.creation.PlayerCreationSubunit
import encore.fancam.Fancam
import encore.fancam.Tags
import encore.session.SessionSubunit
import encore.session.UserSession
import encore.subunit.Subunit
import encore.subunit.scope.ServerScope
import encore.utils.types.Outcome
import encore.utils.types.fold
import encore.venue.Venue
import game.Globals
import kotlin.io.encoding.Base64

/**
 * Server-scoped subunit that handles authentication.
 *
 * `AuthSubunit` requires other subunits:
 * - [AccountSubunit] to get account information for registration or login.
 * - [PlayerCreationSubunit] to create account during registration.
 * - [SessionSubunit] to create session after successful registration or login.
 */
class AuthSubunit(
    private val accountSubunit: AccountSubunit,
    private val creationSubunit: PlayerCreationSubunit,
    private val sessionSubunit: SessionSubunit
) : Subunit<ServerScope> {
    /**
     * Register an account with [username] and [password].
     *
     * A successful registration will also create and return a user session
     * from [SessionSubunit.create].
     *
     * **Note**: The uniqueness of username and email applies. Although
     * [AccountSubunit.usernameExists] or [AccountSubunit.emailExists]
     * is called beforehand, there is still a potential duplicate race.
     * When such thing happens, account won't be registered.
     *
     * Returns:
     * - [Outcome.Fail] if there is an internal repository error.
     * - [Outcome.Ok] with `null` if username or email already exists.
     * - Otherwise [Outcome.Ok] with [UserSession].
     */
    suspend fun register(username: String, password: String, email: String): Outcome<UserSession?> {
        try {
            val playerId = creationSubunit.createPlayer(username = username, password = password, email = email)
            Fancam.trace(Tags.Auth) { "Registered '$username' successfully" }
            val session = sessionSubunit.create(playerId)
            return Outcome.Ok(session)
        } catch (e: Throwable) {
            if (e is MongoWriteException && e.code == 11000) {
                Fancam.error(e, Tags.Auth) { "Duplicate field encountered on '$username' registration" }
                return Outcome.Ok(null)
            }

            Fancam.error(e, Tags.Auth) { "Failed to register '$username'" }
            return Outcome.Fail
        }
    }

    /**
     * Login to the account of [username] with [password].
     *
     * On successful login, this would produce a [UserSession]
     * obtained from calling [SessionSubunit.create].
     *
     * Login of admin should be directed to [loginAsAdmin] instead.
     *
     * Returns:
     * - [Outcome.Fail] if there is an internal repository error.
     * - [Outcome.Ok] with [LoginResult.AccountNotFound] if the associated
     *   player account of [username] is not found.
     * - [Outcome.Ok] with [LoginResult.InvalidCredentials] if the password
     *   does not match.
     * - Otherwise [Outcome.Ok] with [UserSession].
     */
    suspend fun login(username: String, password: String): Outcome<LoginResult> {
        val outcome = accountSubunit.getCredentials(username)
        return outcome.fold(
            onOk = { credentials ->
                if (credentials == null) {
                    Fancam.trace(Tags.Auth) { "Login failed: account with username '$username' is not found" }
                    return Outcome.Ok(LoginResult.AccountNotFound("Account with username '$username' is not found"))
                }

                if (verifyPassword(password, credentials.hashedPassword)) {
                    Fancam.trace(Tags.Auth) { "Login success for '$username'" }
                    val session = sessionSubunit.create(credentials.playerId)
                    Outcome.Ok(LoginResult.Success(session))
                } else {
                    Fancam.trace(Tags.Auth) { "Login failed: wrong password for '$username'" }
                    Outcome.Ok(LoginResult.InvalidCredentials("Wrong password for '$username'"))
                }
            },
            onFail = {
                Fancam.error(tag = Tags.Auth) { "Login failed for '$username'" }
                Outcome.Fail
            }
        )
    }

    /**
     * Login as admin, which creates a reserved admin session.
     *
     * When [EncoreConfig.adminEnabled] is `false`, this will fail returning a `null`.
     *
     * @return [UserSession] with fixed token of [Globals.ADMIN_TOKEN], or `null`
     *                       if admin is not enabled.
     */
    fun loginAsAdmin(): UserSession? {
        if (!Venue.encore.adminEnabled) return null
        return sessionSubunit.create(Globals.ADMIN_PLAYER_ID)
    }

    private fun verifyPassword(password: String, hashed: String): Boolean {
        return Bcrypt.verify(password, Base64.decode(hashed))
    }

    /**
     * Check whether the [username] is available.
     *
     * Returns:
     * - [Outcome.Fail] if there is an internal repository error.
     * - [Outcome.Ok]` = false` if username is equal to [Globals.ADMIN_RESERVED_NAME].
     * - [Outcome.Ok]` = false` if it is already taken.
     * - [Outcome.Ok]` = false` if it contains some prohibited words.
     * - Otherwise [Outcome.Ok]` = true`.
     */
    suspend fun isUsernameAvailable(username: String): Outcome<Boolean> {
        if (username == Globals.ADMIN_RESERVED_NAME) {
            return Outcome.Ok(false)
        }

        val outcome = accountSubunit.usernameExists(username)
        return outcome.fold(
            onOk = { exists ->
                if (exists) {
                    Fancam.trace(Tags.Auth) { "Username '$username' is already taken" }
                    return Outcome.Ok(false)
                }

                // username does not exist, check prohibited words
                val prohibitedWords = emptySet<String>()
                val triggeredWord = prohibitedWords.firstOrNull { word ->
                    username.contains(word, ignoreCase = true)
                }

                if (triggeredWord != null) {
                    Fancam.trace(Tags.Auth) {
                        "Prohibited words triggered on '$username' by word $triggeredWord"
                    }
                    return Outcome.Ok(false)
                }

                Fancam.trace(Tags.Auth) { "Username '$username' is available" }
                Outcome.Ok(true)
            },
            onFail = { Outcome.Fail }
        )
    }

    /**
     * Check whether the [email] is available.
     *
     * Returns:
     * - [Outcome.Fail] if there is an internal repository error.
     * - [Outcome.Ok]` = false` if username is equal to [Globals.ADMIN_RESERVED_NAME].
     * - [Outcome.Ok]` = false` if it is already taken.
     * - [Outcome.Ok]` = false` if it contains some prohibited words.
     * - Otherwise [Outcome.Ok]` = true`.
     *
     * Note: depending on the context, duplicate email may be allowed.
     */
    suspend fun isEmailAvailable(email: String): Outcome<Boolean> {
        if (email == Globals.ADMIN_EMAIL) {
            return Outcome.Ok(false)
        }

        val outcome = accountSubunit.emailExists(email)
        return outcome.fold(
            onOk = { exists ->
                // depending on the context, duplicate email may be allowed
                if (exists) {
                    Fancam.trace { "Email '$email' is already taken" }
                    return Outcome.Ok(false)
                }

                // email does not exist, check email validity
                val isEmailValid = email.contains("@")

                if (!isEmailValid) {
                    Fancam.trace { "Invalid email '$email'" }
                    return Outcome.Ok(false)
                }

                Fancam.trace { "Email '$email' is available" }
                Outcome.Ok(true)
            },
            onFail = { Outcome.Fail }
        )
    }

    override suspend fun debut(scope: ServerScope): Result<Unit> = Result.success(Unit)
    override suspend fun disband(scope: ServerScope): Result<Unit> = Result.success(Unit)

    companion object {
        /**
         * Creates a test instance of [AuthSubunit].
         *
         * @param accountSubunit created via [AccountSubunit.createForTest].
         * @param creationSubunit created via [PlayerCreationSubunit.createForTest].
         * @param sessionSubunit created via [SessionSubunit.createForTest].
         */
        fun createForTest(
            accountSubunit: AccountSubunit = AccountSubunit.createForTest(),
            creationSubunit: PlayerCreationSubunit = PlayerCreationSubunit.createForTest(),
            sessionSubunit: SessionSubunit = SessionSubunit.createForTest()
        ): AuthSubunit {
            return AuthSubunit(accountSubunit, creationSubunit, sessionSubunit)
        }
    }
}
