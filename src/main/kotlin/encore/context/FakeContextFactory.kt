package encore.context

import game.mongo.collection.PlayerId
import encore.network.transport.Connection
import encore.subunit.scope.ServerScope
import game.context.PlayerContext
import game.context.ServerContext
import kotlinx.coroutines.CoroutineScope

/**
 * Fake implementation of [ContextFactory]
 * - [playerContext] creation is solely provided from the input map
 *   [contexts] in the constructor.
 * - [serverContext] creation is provided from constructor, or default with
 *   [game.context.ServerContext.createForTest].
 */
class FakeContextFactory(
    private val contexts: Map<String, PlayerContext>
) : ContextFactory {
    override suspend fun playerContext(
        playerId: PlayerId,
        connection: Connection,
        serverContext: ServerContext
    ): PlayerContext {
        return requireNotNull(contexts[playerId]) { "$playerId not found on input contexts." }
    }

    override suspend fun serverContext(
        appScope: CoroutineScope,
        serverSubunitScope: ServerScope
    ): ServerContext {
        return ServerContext.createForTest()
    }
}
