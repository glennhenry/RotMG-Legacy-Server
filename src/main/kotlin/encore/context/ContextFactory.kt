package encore.context

import encore.network.transport.Connection
import encore.subunit.scope.ServerScope
import game.context.PlayerContext
import game.context.ServerContext
import game.mongo.collection.PlayerId
import kotlinx.coroutines.CoroutineScope

/**
 * Represent a factory responsible for context objects creation such as
 * [game.context.PlayerContext] and [game.context.ServerContext].
 */
interface ContextFactory {
    /**
     * Create [game.context.PlayerContext] for [playerId].
     *
     * @param playerId Unique identifier of the player.
     * @param connection [Connection] object.
     * @param serverContext [game.context.ServerContext] object.
     */
    suspend fun playerContext(playerId: PlayerId, connection: Connection, serverContext: ServerContext): PlayerContext

    /**
     * Create [ServerContext].
     *
     * @param appScope The application root coroutine scope.
     * @param serverSubunitScope Server subunit scope.
     */
    suspend fun serverContext(
        appScope: CoroutineScope,
        serverSubunitScope: ServerScope
    ): ServerContext
}
