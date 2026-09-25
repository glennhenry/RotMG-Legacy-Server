package encore.account

import game.mongo.collection.PlayerAccount
import game.mongo.collection.PlayerId
import encore.account.model.Credentials
import encore.account.model.Profile

/**
 * No-operation implementation of [AccountRepository] used for testing purposes.
 */
class BlankAccountRepository : AccountRepository {
    override suspend fun getAccountByPlayerId(playerId: PlayerId): Result<PlayerAccount?> = TODO("NO OPERATION")
    override suspend fun getAccountByUsername(username: String): Result<PlayerAccount?> = TODO("NO OPERATION")
    override suspend fun getPlayerIdByUsername(username: String): Result<PlayerId?> = TODO("NO OPERATION")
    override suspend fun getProfile(playerId: PlayerId): Result<Profile?> = TODO("NO OPERATION")
    override suspend fun getCredentials(username: String): Result<Credentials?> = TODO("NO OPERATION")
    override suspend fun updatePlayerAccount(playerId: PlayerId, account: PlayerAccount): Result<Unit> = TODO("NO OPERATION")
    override suspend fun updateProfile(playerId: PlayerId, profile: Profile): Result<Unit> = TODO("NO OPERATION")
    override suspend fun updateLastActivity(playerId: PlayerId, lastActivity: Long): Result<Unit> = Result.success(Unit)
    override suspend fun usernameExists(username: String): Result<Boolean> = TODO("NO OPERATION")
    override suspend fun emailExists(email: String): Result<Boolean> = TODO("NO OPERATION")
}
