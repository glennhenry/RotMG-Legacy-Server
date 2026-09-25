package testUtils

import encore.context.FakeContextFactory
import game.context.PlayerContext
import game.context.PlayerSubunits
import game.context.ServerContext
import game.mongo.collection.PlayerAccount
import game.mongo.collection.PlayerId
import encore.network.fanchant.Fanchant
import encore.network.handler.HandlerContext
import encore.network.transport.ConnectionIdentity
import encore.network.transport.TestConnection
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.test.StandardTestDispatcher

/**
 * Handler testing utility to encapsulate the relevant states to test message handlers.
 */
data class HandlerTestState<T : Fanchant>(
    val playerId: PlayerId = "testPlayerId123",
    val playerName: String = "TestPlayerABC",
    val message: T,
    val account: PlayerAccount = createAccount(playerId, playerName, "anypassword"),
    val subunits: PlayerSubunits,
    val connectionScope: CoroutineScope = CoroutineScope(StandardTestDispatcher())
) {
    val connection = TestConnection(
        connectionScope = connectionScope,
        identity = ConnectionIdentity(
            playerId = playerId,
            username = playerName,
            remoteAddress = "N/A"
        )
    )

    val playerContext = PlayerContext(playerId, connection, account, subunits)
    val contextFactory = FakeContextFactory(mapOf(playerId to playerContext))
    val serverContext = ServerContext.createForTest(contextFactory = contextFactory)
    val handlerContext: HandlerContext<T> = HandlerContext(
        fanchant = message,
        connection = connection
    )
}
