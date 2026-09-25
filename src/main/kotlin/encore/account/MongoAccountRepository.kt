package encore.account

import com.mongodb.client.model.Filters
import com.mongodb.client.model.Projections
import com.mongodb.client.model.Updates
import com.mongodb.kotlin.client.coroutine.MongoCollection
import encore.account.model.Credentials
import encore.account.model.Profile
import encore.datastore.*
import game.mongo.collection.PlayerAccount
import game.mongo.collection.PlayerId
import kotlinx.coroutines.flow.firstOrNull
import org.bson.codecs.pojo.annotations.BsonId

/** `playerId`*/
val FieldPlayerId = PlayerAccount::playerId.name

/** `username`*/
val FieldUsername = PlayerAccount::username.name

/** `email`*/
val FieldEmail = PlayerAccount::email.name

/** `hashedPassword`*/
val FieldPassword = PlayerAccount::hashedPassword.name

/** `profile`*/
val FieldProfile = PlayerAccount::profile.name

/** `profile.lastActiveAt`*/
val FieldProfileLastActive = "$FieldProfile.${Profile::lastActiveAt.name}"

/**
 * [AccountRepository] implementation using MongoDB.
 */
class MongoAccountRepository(val accountCollection: MongoCollection<PlayerAccount>) : AccountRepository {
    override suspend fun getAccountByPlayerId(playerId: PlayerId): Result<PlayerAccount> {
        return runMongoCatching {
            accountCollection
                .find(Filters.eq(FieldPlayerId, playerId))
                .firstOrNull()
        }
    }

    override suspend fun getAccountByUsername(username: String): Result<PlayerAccount> {
        return runMongoCatching {
            accountCollection
                .find(Filters.eq(FieldUsername, username))
                .firstOrNull()
        }
    }

    override suspend fun getPlayerIdByUsername(username: String): Result<PlayerId> {
        return runMongoCatching {
            accountCollection
                .withDocumentClass<QueryPlayerId>()
                .find(Filters.eq(FieldUsername, username))
                .projection(
                    Projections.fields(
                        Projections.include(FieldPlayerId),
                        Projections.excludeId()
                    )
                )
                .firstOrNull()
                ?.playerId
        }
    }

    override suspend fun getProfile(playerId: PlayerId): Result<Profile?> {
        return runMongoCatching {
            accountCollection
                .withDocumentClass<QueryProfile>()
                .find(Filters.eq(FieldPlayerId, playerId))
                .projection(Projections.include(FieldProfile))
                .firstOrNull()
                ?.profile
        }
    }

    override suspend fun getCredentials(username: String): Result<Credentials?> {
        return runMongoCatching {
            val account = accountCollection
                .withDocumentClass<QueryCredentials>()
                .find(Filters.eq(FieldUsername, username))
                .projection(Projections.include(FieldPassword, FieldPlayerId))
                .firstOrNull()

            if (account == null) {
                return Result.success(null)
            }

            val playerId = account.playerId
            val hashedPassword = account.hashedPassword
            return Result.success(Credentials(playerId, hashedPassword))
        }
    }

    override suspend fun updatePlayerAccount(
        playerId: PlayerId,
        account: PlayerAccount
    ): Result<Unit> {
        return runMongoCatching {
            val filter = Filters.eq(FieldPlayerId, playerId)
            accountCollection
                .replaceOne(filter, account)
                .throwIfNothingMatched("updatePlayerAccount not updated for $playerId", { filter })
        }
    }

    override suspend fun updateProfile(
        playerId: PlayerId,
        profile: Profile
    ): Result<Unit> {
        return runMongoCatching {
            val filter = Filters.eq(FieldPlayerId, playerId)
            val update = Updates.set(FieldProfile, profile)
            accountCollection
                .updateOne(filter, update)
                .throwIfNothingMatched("updateProfile not updated for $playerId", { filter })
        }
    }

    override suspend fun updateLastActivity(
        playerId: PlayerId,
        lastActivity: Long
    ): Result<Unit> {
        return runMongoCatching {
            val filter = Filters.eq(FieldPlayerId, playerId)
            val update = Updates.set(FieldProfileLastActive, lastActivity)
            accountCollection
                .updateOne(filter, update)
                .throwIfNothingMatched("updateLastActivity not updated for $playerId", { filter })
        }
    }

    override suspend fun usernameExists(username: String): Result<Boolean> {
        return runMongoCatching {
            accountCollection
                .find(Filters.eq(FieldUsername, username))
                .projection(null)
                .firstOrNull() != null
        }
    }

    override suspend fun emailExists(email: String): Result<Boolean> {
        return runMongoCatching {
            accountCollection
                .find(Filters.eq(FieldEmail, email))
                .projection(null)
                .firstOrNull() != null
        }
    }
}

/**
 * Mongo projection class to query the `playerId` of [PlayerAccount].
 */
data class QueryPlayerId(
    @field:BsonId val id: String? = null,
    val playerId: PlayerId
)

/**
 * Mongo projection class to query the `playerId` and `hashedPassword` of [PlayerAccount].
 */
data class QueryCredentials(
    @field:BsonId val id: String? = null,
    val playerId: PlayerId,
    val hashedPassword: String
)

/**
 * Mongo projection class to query the `profile` of [PlayerAccount].
 */
data class QueryProfile(
    @field:BsonId val id: String? = null,
    val profile: Profile
)
