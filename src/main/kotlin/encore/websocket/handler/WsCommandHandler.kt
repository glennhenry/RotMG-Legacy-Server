package encore.websocket.handler

import game.context.ServerContext
import encore.serialization.JSON
import encore.websocket.WebSocketMessage
import encore.websocket.WebSocketMessageType
import encore.websocket.respond
import io.ktor.server.websocket.*
import kotlinx.serialization.json.buildJsonObject
import kotlinx.serialization.json.decodeFromJsonElement
import kotlinx.serialization.json.put

/**
 * WebSocket handler for the command input.
 */
class WsCommandHandler(private val serverContext: ServerContext) : WebSocketHandler {
    override val type: String = WebSocketMessageType.CMD_INPUT

    override suspend fun handle(
        message: WebSocketMessage,
        session: DefaultWebSocketServerSession
    ) {
        val rawCmd = JSON.json.decodeFromJsonElement<String>(message.payload)
        val result = serverContext.commandDispatcher.handleRawCommand(rawCmd, serverContext)

        session.respond(
            type = WebSocketMessageType.CMD_OUTPUT,
            payload = buildJsonObject {
                put("result", result.toString())
            }
        )
    }
}
