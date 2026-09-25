package encore.extra

import com.mongodb.client.model.Filters
import com.mongodb.client.model.Updates
import com.mongodb.kotlin.client.coroutine.MongoCollection
import encore.account.FieldPlayerId
import encore.datastore.runMongoCatching
import encore.datastore.throwIfNothingMatched
import game.mongo.collection.PlayerId
import game.mongo.collection.PlayerServerObjects
import kotlinx.coroutines.flow.firstOrNull

class MongoPlayerExtraRepository(
    private val psCollection: MongoCollection<PlayerServerObjects>
) : PlayerExtraRepository {
    override suspend fun getExtra(playerId: PlayerId, key: String): Result<String?> {
        return runMongoCatching {
            psCollection
                .find(Filters.eq(FieldPlayerId, playerId))
                .firstOrNull()
                ?.extra[key]
        }
    }

    override suspend fun getAllExtra(playerId: PlayerId, key: String): Result<Map<String, String>?> {
        return runMongoCatching {
            psCollection
                .find(Filters.eq(FieldPlayerId, playerId))
                .firstOrNull()
                ?.extra
        }
    }

    override suspend fun updateExtra(
        playerId: PlayerId, key: String, value: String
    ): Result<Unit> {
        return runMongoCatching {
            val filter = Filters.eq(FieldPlayerId, playerId)
            val update = Updates.set("extra.$key", value)
            psCollection.updateOne(filter, update)
                .throwIfNothingMatched("updateExtra") { filter }
        }
    }

    override suspend fun deleteExtra(
        playerId: PlayerId,
        key: String
    ): Result<Unit> {
        return runMongoCatching {
            val filter = Filters.eq(FieldPlayerId, playerId)
            val update = Updates.unset("extra.$key")
            psCollection.updateOne(filter, update)
                .throwIfNothingMatched("deleteExtra") { filter }
        }
    }
}
