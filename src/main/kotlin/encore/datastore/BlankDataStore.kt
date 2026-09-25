package encore.datastore

import game.mongo.collection.PlayerAccount
import game.mongo.collection.PlayerId
import game.mongo.collection.PlayerObjects
import game.mongo.collection.PlayerServerObjects

/**
 * No-operation implementation for [DataStore] used for testing purposes.
 */
class BlankDataStore : DataStore {
    override suspend fun awaitInit() = Unit
    override suspend fun accountExists(playerId: PlayerId): Boolean = TODO("NO OPERATION")
    override suspend fun insert(account: PlayerAccount, playerObjects: PlayerObjects, playerServerObjects: PlayerServerObjects): Result<Unit> = TODO("NO OPERATION")
    override suspend fun delete(playerId: PlayerId): Result<Unit> = TODO("NO OPERATION")
    override suspend fun shutdown() = TODO("NO OPERATION")
}
