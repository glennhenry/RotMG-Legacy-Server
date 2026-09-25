package encore.extra

import game.mongo.collection.PlayerId

import game.mongo.collection.PlayerServerObjects

/**
 * Repository handling [PlayerServerObjects.extra] concern.
 */
interface PlayerExtraRepository {
    /**
     * Retrieve the extra data of [key] owned by [playerId].
     * @return [Result.failure] for any repository error,
     *         otherwise [Result.success] with the value.
     */
    suspend fun getExtra(playerId: PlayerId, key: String): Result<String?>

    /**
     * Retrieve all extra data owned by [playerId].
     * @return [Result.failure] for any repository error,
     *         otherwise [Result.success] with the value.
     */
    suspend fun getAllExtra(playerId: PlayerId, key: String): Result<Map<String, String>?>

    /**
     * Update the extra data of [key] owned by [playerId] by [value].
     * @return [Result.failure] for any repository error, otherwise [Result.success].
     */
    suspend fun updateExtra(playerId: PlayerId, key: String, value: String): Result<Unit>

    /**
     * Delete the extra data of [key] owned by [playerId].
     * @return [Result.failure] for any repository error, otherwise [Result.success].
     */
    suspend fun deleteExtra(playerId: PlayerId, key: String): Result<Unit>
}
