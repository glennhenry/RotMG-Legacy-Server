package encore.datastore

import game.mongo.collection.PlayerAccount
import game.mongo.collection.PlayerId
import game.mongo.collection.PlayerObjects
import game.mongo.collection.PlayerServerObjects

/**
 * Persistence component that owns access to the core database collections
 * and responsible for insertion and deletion.
 *
 * Implementation defines insert and deletion to/from the underlying store.
 * It shouldn't contain retrieval operation or alteration on certain fields.
 * This should be done by separate repository per-domain.
 */
interface DataStore {
    /**
     * Ensures the data store is fully initialized.
     *
     * This suspend function will wait until any asynchronous setup is complete.
     */
    suspend fun awaitInit()

    /**
     * Returns whether an account associated with [playerId] exists.
     */
    suspend fun accountExists(playerId: PlayerId): Boolean

    /**
     * Insert these documents for a new player creation.
     * @return [Result] type denoting success or failure.
     */
    suspend fun insert(
        account: PlayerAccount,
        playerObjects: PlayerObjects,
        playerServerObjects: PlayerServerObjects
    ): Result<Unit>

    /**
     * Delete documents owned by the player identified by [playerId].
     */
    suspend fun delete(playerId: PlayerId): Result<Unit>

    /**
     * Shutdown the data store.
     *
     * This should contains the necessary clean-up code before closing.
     */
    suspend fun shutdown()
}
