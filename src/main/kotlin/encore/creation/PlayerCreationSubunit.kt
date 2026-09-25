package encore.creation

import encore.datastore.BlankDataStore
import encore.datastore.DataStore
import encore.fancam.Fancam
import encore.fancam.Tags
import encore.subunit.Subunit
import encore.subunit.scope.ServerScope
import encore.utils.types.isOk
import game.Globals
import game.mongo.collection.PlayerId

/**
 * Server-scoped subunit responsible for player creation.
 *
 * Responsible for orchestrating the creation of a new player.
 * It consults [PlayerCreationFactory] for producing new documents
 * and updating existing server data collection.
 *
 * @property dataStore [DataStore] implementation for inserting new documents.
 * @property factory [PlayerCreationFactory] producing documents and updating server collection.
 */
class PlayerCreationSubunit(
    private val dataStore: DataStore,
    private val factory: PlayerCreationFactory
) : Subunit<ServerScope> {
    /**
     * Create a player account with the specified [username], [password], and [email].
     *
     * Email is optional and will be defaulted to `username@email.com`
     *
     * @return [PlayerId] of the newly created player
     * @throws [Throwable] an exception type from the underlying datastore or
     *         [IllegalStateException] when the account creation failed without any exception passed.
     */
    suspend fun createPlayer(
        username: String, password: String,
        email: String = "$username@email.com"
    ): PlayerId {
        val playerId = factory.playerId(false)
        val account = factory.account(playerId, username, password, email)
        val playerObjects = factory.playerObjects(playerId)
        val playerServerObjects = factory.playerServerObjects(playerId)

        val dataStoreResult = dataStore.insert(account, playerObjects, playerServerObjects)
        val serverObjReport = factory.updateServerObjects(account, playerObjects)

        if (dataStoreResult.isSuccess && serverObjReport.isOk()) {
            return playerId
        }

        Fancam.error(tag = Tags.Creation) {
            "Account creation failed for $username (dataStoreResult.isSuccess=${dataStoreResult.isSuccess}, serverObjReport.isOk=${serverObjReport.isOk()})"
        }

        throw dataStoreResult.exceptionOrNull()
            ?: IllegalStateException("Account creation failed with unknown scandal (exception was null)")
    }

    /**
     * Create a reserved admin account if it doesn't exist.
     *
     * @param alwaysRecreate Whether to always recreate the account.
     * @throws [Throwable] an exception type from the underlying datastore or
     *         [IllegalStateException] when the account creation failed without any exception passed.
     */
    suspend fun createAdmin(adminData: Globals, alwaysRecreate: Boolean = false) {
        if (alwaysRecreate) {
            dataStore.delete(adminData.ADMIN_PLAYER_ID)
        } else if (dataStore.accountExists(adminData.ADMIN_PLAYER_ID)) {
            Fancam.info(Tags.Creation) { "Ignoring admin account creation (already exists)" }
            return
        }

        val playerId = factory.playerId(true)
        val account = factory.account(
            playerId, Globals.ADMIN_USERNAME,
            Globals.ADMIN_EMAIL, Globals.ADMIN_PASSWORD
        )
        val playerObjects = factory.playerObjects(playerId)
        val playerServerObjects = factory.playerServerObjects(playerId)

        val dataStoreResult = dataStore.insert(account, playerObjects, playerServerObjects)
        val serverObjReport = factory.updateServerObjects(account, playerObjects)

        if (dataStoreResult.isSuccess && serverObjReport.isOk()) {
            Fancam.info(Tags.Creation) { "New admin account created" }
        } else {
            Fancam.error(tag = Tags.Creation) {
                "Admin creation failed (dataStoreResult.isSuccess=${dataStoreResult.isSuccess}, serverObjReport.isOk=${serverObjReport.isOk()})"
            }

            throw dataStoreResult.exceptionOrNull()
                ?: IllegalStateException("Admin creation failed with unknown scandal (exception was null)")
        }
    }

    override suspend fun debut(scope: ServerScope): Result<Unit> = Result.success(Unit)
    override suspend fun disband(scope: ServerScope): Result<Unit> = Result.success(Unit)

    companion object {
        /**
         * Creates a test instance of [PlayerCreationSubunit].
         *
         * @param dataStore dependency for persistence.
         * Use [BlankDataStore] when the behavior is not relevant to the test.
         * @param factory [PlayerCreationFactory].
         */
        fun createForTest(
            dataStore: DataStore = BlankDataStore(),
            factory: PlayerCreationFactory = BlankPlayerCreationFactory()
        ): PlayerCreationSubunit {
            return PlayerCreationSubunit(dataStore, factory)
        }
    }
}
