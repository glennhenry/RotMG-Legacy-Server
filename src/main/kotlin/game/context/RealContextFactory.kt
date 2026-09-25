package game.context

import com.mongodb.kotlin.client.coroutine.MongoDatabase
import encore.account.AccountSubunit
import encore.account.MongoAccountRepository
import encore.acts.ActIdStore
import encore.acts.StageActDirector
import encore.auth.AuthSubunit
import encore.backstage.command.CommandDispatcher
import encore.context.*
import encore.creation.PlayerCreationSubunit
import encore.datastore.MongoDataStore
import encore.extra.MongoPlayerExtraRepository
import encore.extra.PlayerExtraSubunit
import encore.network.lifecycle.PlayerLifecycleHandler
import encore.network.transport.Connection
import encore.presence.PlayerPresenceSubunit
import encore.session.SessionSubunit
import encore.subunit.scope.PlayerScope
import encore.subunit.scope.ServerScope
import encore.time.TimeCenter
import encore.utils.types.okOrNull
import encore.websocket.WebSocketManager
import game.RealPlayerCreationFactory
import game.mongo.MongoCollections
import game.mongo.collection.PlayerId
import kotlinx.coroutines.CoroutineScope

/**
 * Real implementation of [ContextFactory].
 *
 * Context creation here is user-owned and must be updated accordingly.
 *
 * @property collections Mongo collection names
 * @property mongoDatabase Mongo database
 */
class RealContextFactory(
    private val collections: MongoCollections,
    private val mongoDatabase: MongoDatabase
) : ContextFactory {
    override suspend fun playerContext(
        playerId: PlayerId,
        connection: Connection,
        serverContext: ServerContext
    ): PlayerContext {
        val account = requireNotNull(
            serverContext.subunits.account.getAccountByPlayerId(playerId).okOrNull()
        ) {
            "Account not exist during context creation for $playerId"
        }

        val subunits = PlayerSubunits(example = "REPLACE")
        val scope = PlayerScope(playerId)
        subunits.debut(scope)

        return PlayerContext(
            playerId = playerId,
            connection = connection,
            account = account,
            subunits = subunits
        )
    }

    override suspend fun serverContext(
        appScope: CoroutineScope,
        serverSubunitScope: ServerScope,
    ): ServerContext {
        /*... setup ServerContext ...*/

        val dataStore = MongoDataStore(db = mongoDatabase, collections = collections)
            .also { it.awaitInit() }

        val accountRepository = MongoAccountRepository(
            accountCollection = mongoDatabase.getCollection(collections.playerAccount)
        )
        val extraRepository = MongoPlayerExtraRepository(mongoDatabase.getCollection(collections.playerServerObjects))
        val contextRegistry = ContextRegistry(RealContextFactory(collections, mongoDatabase))
        val creationFactory = RealPlayerCreationFactory()
        val stageActDirector = StageActDirector(
            timeSource = TimeCenter.source,
            actStore = ActIdStore
        )
        val commandDispatcher = CommandDispatcher()
        val playerLifecycleHandler = PlayerLifecycleHandler(logEachHook = true)
        val webSocketManager = WebSocketManager()

        // setup ServerSubunits
        val accountSubunit = AccountSubunit(accountRepository)
        val playerPresenceSubunit = PlayerPresenceSubunit()
        val sessionSubunit = SessionSubunit(appScope, TimeCenter.source)
        val playerCreationSubunit = PlayerCreationSubunit(dataStore, creationFactory)
        val authSubunit = AuthSubunit(accountSubunit, playerCreationSubunit, sessionSubunit)
        val extra = PlayerExtraSubunit(extraRepository)

        val subunits = ServerSubunits(
            account = accountSubunit,
            presence = playerPresenceSubunit,
            auth = authSubunit,
            session = sessionSubunit,
            creation = playerCreationSubunit,
            extra = extra
        )

        // debut all subunits
        subunits.debut(serverSubunitScope)

        val serverContext = ServerContext(
            dataStore = dataStore,
            contextRegistry = contextRegistry,
            stageActDirector = stageActDirector,
            commandDispatcher = commandDispatcher,
            playerLifecycleHandler = playerLifecycleHandler,
            webSocketManager = webSocketManager,
            subunits = subunits
        )

        return serverContext
    }
}
