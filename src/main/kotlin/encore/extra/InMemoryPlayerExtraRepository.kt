package encore.extra

import game.mongo.collection.PlayerId

class InMemoryPlayerExtraRepository(
    private val initialMap: MutableMap<String, MutableMap<String, String>> = mutableMapOf()
) : PlayerExtraRepository {
    override suspend fun getExtra(
        playerId: PlayerId,
        key: String
    ): Result<String?> {
        return Result.success(initialMap[playerId]?.get(key))
    }

    override suspend fun getAllExtra(
        playerId: PlayerId,
        key: String
    ): Result<Map<String, String>?> {
        return Result.success(initialMap[playerId])
    }

    override suspend fun updateExtra(
        playerId: PlayerId,
        key: String,
        value: String
    ): Result<Unit> {
        initialMap[playerId]?.set(key, value)
        return Result.success(Unit)
    }

    override suspend fun deleteExtra(
        playerId: PlayerId,
        key: String
    ): Result<Unit> {
        initialMap[playerId]?.remove(key)
        return Result.success(Unit)
    }
}
