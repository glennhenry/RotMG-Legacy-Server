package encore.context

import game.mongo.collection.PlayerId
import encore.network.transport.Connection
import game.context.PlayerContext
import game.context.ServerContext
import java.util.concurrent.ConcurrentHashMap

/**
 * Manages [game.context.PlayerContext] of all connected players.
 *
 * This class is responsible for:
 * - Creating, registering and storing [game.context.PlayerContext].
 * - Provide lookup during gameplay.
 *
 * @property factory [ContextFactory] instance used for creating contexts.
 */
class ContextRegistry(private val factory: ContextFactory) {
    private val players = ConcurrentHashMap<String, PlayerContext>()

    /**
     * Register [PlayerContext] for the given player.
     *
     * Context creation depends on [ContextFactory] from the constructor.
     *
     * @param playerId Unique identifier of the player.
     * @param connection [Connection] object.
     * @param serverContext [game.context.ServerContext] object.
     * @return The newly created context.
     */
    suspend fun createContext(playerId: PlayerId, connection: Connection, serverContext: ServerContext): PlayerContext {
        val context = factory.playerContext(playerId, connection, serverContext)
        players[playerId] = context
        return context
    }

    /**
     * Get [PlayerContext] associated with [playerId], if exists.
     */
    fun getContext(playerId: PlayerId): PlayerContext? {
        return players[playerId]
    }

    /**
     * Remove [PlayerContext] associated with [playerId].
     */
    fun removeContext(playerId: PlayerId) {
        players.remove(playerId)
    }
}
