package encore.network.stage

import game.context.ServerContext
import kotlinx.coroutines.CoroutineScope

/**
 * Represent a server.
 */
interface Stage {
    /**
     * Initialize the server with the given coroutine scope and [ServerContext].
     */
    suspend fun initialize(scope: CoroutineScope, context: ServerContext)

    /**
     * Signal the server to start accepting connections.
     */
    suspend fun start()

    /**
     * Signal the server to stop serving connections and do the necessary cleanup.
     */
    suspend fun shutdown()
}