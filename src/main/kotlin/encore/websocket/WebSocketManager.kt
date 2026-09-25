package encore.websocket

import encore.fancam.Fancam
import encore.fancam.INDENT
import encore.fancam.Tags
import encore.utils.support.className
import encore.websocket.handler.WebSocketHandler
import io.ktor.server.websocket.*
import java.util.*
import java.util.concurrent.ConcurrentHashMap

typealias ClientSessions = ConcurrentHashMap<String, DefaultWebSocketServerSession>

/**
 * Track websocket connections and dispatch incoming message to handlers.
 * This websocket system is mostly used to connect with the external devtools.
 *
 * Usage:
 * - Register handler via [registerHandler].
 * - Add client with [addClient].
 * - Dispatch message to handlers via [handleMessage].
 */
class WebSocketManager {
    private val clients = ClientSessions()

    /**
     * Add a new websocket session.
     *
     * Does nothing if the client was added before.
     *
     * @param clientId Unique identifier to associate with the session.
     * @param session The websocket connection.
     */
    fun addClient(clientId: String, session: DefaultWebSocketServerSession) {
        if (!clients.contains(clientId)) {
            clients[clientId] = session
        }
    }

    /**
     * Remove the tracked websocket session associated with [clientId].
     */
    fun removeClient(clientId: String) {
        clients.remove(clientId)
    }

    /**
     * Returns the `clientId` of all actively tracked websocket session.
     */
    fun getAllClients(): Enumeration<String> {
        return clients.keys()
    }

    /**
     * Get the associated websocket session of [clientId].
     *
     * @return The websocket session which may be `null`.
     */
    fun getSessionFromId(clientId: String): DefaultWebSocketServerSession? {
        return clients[clientId]
    }

    private val handlers = mutableMapOf<String, WebSocketHandler>()

    /**
     * Register [wsHandler] to handle message of type [WebSocketHandler.type].
     *
     * The handling system doesn't support multiple handler per message type.
     * Duplicate registration of the same type will be skipped.
     */
    fun registerHandler(wsHandler: WebSocketHandler) {
        if (handlers[wsHandler.type] != null) {
            Fancam.warn(Tags.Websocket) { "WebSocketHandler for '${wsHandler.type}' is already registered, skipping." }
        } else {
            handlers[wsHandler.type] = wsHandler
        }
    }

    /**
     * Handle the websocket [message] received from the client [session].
     *
     * If no handler is found, the message will simply be logged and left unhandled.
     */
    suspend fun handleMessage(session: DefaultWebSocketServerSession, message: WebSocketMessage) {
        val handler = handlers[message.type]

        Fancam.debug(Tags.Websocket) {
            buildString {
                appendLine("##### [WebSocket Receive]")
                appendLine("$INDENT type       : ${message.type}")
                appendLine("$INDENT payload    : ${message.payload}")
                append("$INDENT handled by : ${handler?.className() ?: "[Unhandled]"}")
            }
        }

        if (handler == null) {
            Fancam.warn(Tags.Websocket) { "No handler is registered for WebSocket message '${message.type}'" }
        }

        handler?.handle(message, session)
    }
}
