package encore.account

import encore.account.model.Credentials
import encore.account.model.Profile
import encore.auth.AuthSubunit
import game.mongo.collection.PlayerAccount
import game.mongo.collection.PlayerId
import encore.fancam.Fancam
import encore.fancam.Tags
import encore.subunit.Subunit
import encore.subunit.scope.ServerScope
import encore.utils.types.Outcome
import encore.utils.types.Report
import encore.utils.types.toOutcome
import encore.utils.types.toReport

/**
 * Server subunits that handles [PlayerAccount] concerns from [AccountRepository].
 *
 * This subunit focuses on abstracting low-level API of `AccountRepository`.
 * Every operations here return a [Report] or [Outcome] type. It doesn't interpret
 * or handle the result from repository. Instead, callers (e.g., [AuthSubunit] should be
 * responsible for it.
 *
 * @property accountRepository [AccountRepository] implementation.
 */
class AccountSubunit(private val accountRepository: AccountRepository) : Subunit<ServerScope> {
    /**
     * Returns an [Outcome] containing [PlayerAccount] associated with [playerId].
     * - [Outcome.Fail] when there is internal repository error.
     * - [Outcome.Ok] with `null` if account does not exist.
     * - [Outcome.Ok] with the account otherwise.
     */
    suspend fun getAccountByPlayerId(playerId: PlayerId): Outcome<PlayerAccount?> {
        return accountRepository.getAccountByPlayerId(playerId)
            .onFailure {
                Fancam.error(it, Tags.Account) {
                    "getAccountByPlayerId failed: repository scandal for '$playerId'"
                }
            }
            .toOutcome { account -> return Outcome.Ok(account) }
    }

    /**
     * Returns an [Outcome] containing [PlayerAccount] associated with [username].
     * - [Outcome.Fail] when there is internal repository error.
     * - [Outcome.Ok] with `null` if account does not exist.
     * - [Outcome.Ok] with the account otherwise.
     */
    suspend fun getAccountByUsername(username: String): Outcome<PlayerAccount?> {
        return accountRepository.getAccountByUsername(username)
            .onFailure {
                Fancam.error(it, Tags.Account) {
                    "getAccountByUsername failed: repository scandal for '$username'"
                }
            }
            .toOutcome { account -> return Outcome.Ok(account) }
    }

    /**
     * Returns an [Outcome] containing [PlayerId] associated with [username].
     * - [Outcome.Fail] when there is internal repository error.
     * - [Outcome.Ok] with `null` if account does not exist.
     * - [Outcome.Ok] with the `playerId` otherwise.
     */
    suspend fun getPlayerIdByUsername(username: String): Outcome<PlayerId?> {
        return accountRepository.getPlayerIdByUsername(username)
            .onFailure {
                Fancam.error(it, Tags.Account) {
                    "getPlayerIdByUsername failed: repository scandal for '$username'"
                }
            }
            .toOutcome { playerId -> return Outcome.Ok(playerId) }
    }

    /**
     * Returns an [Outcome] containing [Profile] associated with [playerId].
     * - [Outcome.Fail] when there is internal repository error.
     * - [Outcome.Ok] with `null` if account does not exist.
     * - [Outcome.Ok] with the `profile` otherwise.
     */
    suspend fun getProfile(playerId: PlayerId): Outcome<Profile?> {
        return accountRepository.getProfile(playerId)
            .onFailure {
                Fancam.error(it, Tags.Account) {
                    "getProfile failed: repository scandal for '$playerId'"
                }
            }
            .toOutcome { profile -> return Outcome.Ok(profile) }
    }

    /**
     * Returns an [Outcome] containing the credentials of [username].
     * - [Outcome.Fail] when there is internal repository error.
     * - [Outcome.Ok] with the credentials result.
     */
    suspend fun getCredentials(username: String): Outcome<Credentials?> {
        return accountRepository.getCredentials(username)
            .onFailure {
                Fancam.error(it, Tags.Account) {
                    "getCredentials failed: repository scandal for '$username'"
                }
                return Outcome.Fail
            }
            .toOutcome { credentials ->
                return Outcome.Ok(credentials)
            }
    }

    /**
     * Update [PlayerAccount] of [playerId].
     * @return [Report] type denoting success or failure.
     */
    suspend fun updatePlayerAccount(playerId: PlayerId, account: PlayerAccount): Report {
        return accountRepository.updatePlayerAccount(playerId, account)
            .onFailure {
                Fancam.error(it, Tags.Account) {
                    "updatePlayerAccount failed: repository scandal for '$playerId' on update with $account"
                }
                return Report.Fail
            }
            .toReport()
    }

    /**
     * Update [PlayerAccount] of [playerId].
     * @return [Report] type denoting success or failure.
     */
    suspend fun updateProfile(playerId: PlayerId, profile: Profile): Report {
        return accountRepository.updateProfile(playerId, profile)
            .onFailure {
                Fancam.error(it, Tags.Account) {
                    "updateProfile failed: repository scandal for '$playerId' on update with $profile"
                }
                return Report.Fail
            }
            .toReport()
    }

    /**
     * Update the last activity of [playerId].
     * @return [Report] type denoting success or failure.
     */
    suspend fun updateLastActivity(playerId: PlayerId, lastActivity: Long): Report {
        return accountRepository.updateLastActivity(playerId, lastActivity)
            .onFailure {
                Fancam.error(it, Tags.Account) {
                    "updateLastActivity failed: repository scandal for '$playerId', lastActivity=$lastActivity"
                }
            }
            .toReport()
    }

    /**
     * Returns an [Outcome] describing whether [username] exists or not.
     * - [Outcome.Fail] when there is internal repository error.
     * - [Outcome.Ok] with the existence result.
     */
    suspend fun usernameExists(username: String): Outcome<Boolean> {
        return accountRepository.usernameExists(username)
            .onFailure {
                Fancam.error(it, Tags.Account) {
                    "Username check failed: repository scandal for '$username'"
                }
            }
            .toOutcome { exists -> return Outcome.Ok(exists) }
    }

    /**
     * Returns an [Outcome] describing whether [email] exists or not.
     * - [Outcome.Fail] when there is internal repository error.
     * - [Outcome.Ok] with the existence result.
     */
    suspend fun emailExists(email: String): Outcome<Boolean> {
        return accountRepository.emailExists(email)
            .onFailure {
                Fancam.error(it, Tags.Account) {
                    "Email check failed: repository scandal for '$email'"
                }
            }
            .toOutcome { exists -> return Outcome.Ok(exists) }
    }

    override suspend fun debut(scope: ServerScope): Result<Unit> = Result.success(Unit)
    override suspend fun disband(scope: ServerScope): Result<Unit> = Result.success(Unit)

    companion object {
        /**
         * Creates a test instance of [AccountSubunit].
         *
         * @param accountRepository use [BlankAccountRepository] when not under test.
         */
        fun createForTest(
            accountRepository: AccountRepository = BlankAccountRepository()
        ): AccountSubunit {
            return AccountSubunit(accountRepository)
        }
    }
}
