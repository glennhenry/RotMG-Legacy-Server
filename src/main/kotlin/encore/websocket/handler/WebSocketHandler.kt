package encore.websocket.handler

import encore.websocket.WebSocketMessage
import io.ktor.server.websocket.DefaultWebSocketServerSession

/**
 * Represent a handler for the WebSocket communication system.
 */
interface WebSocketHandler {
    /**
     * The type of websocket message this handler is responsible for.
     */
    val type: String

    /**
     * Handle the websocket [message] from [session].
     */
    suspend fun handle(message: WebSocketMessage, session: DefaultWebSocketServerSession)
}
