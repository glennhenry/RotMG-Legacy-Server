package encore.websocket

import encore.fancam.Fancam
import encore.fancam.INDENT
import encore.fancam.Tags
import encore.serialization.JSON
import io.ktor.server.websocket.DefaultWebSocketServerSession
import io.ktor.websocket.Frame
import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonElement

/**
 * Represents a WebSocket message exchanged between client and server.
 *
 * Each message is encoded as JSON and transmitted as texts.
 * A message contains:
 * - `type` field which is a string identifier used to distinguish
 *   the purpose as well as the payload structure of a websocket message.
 * - An optional, non-nullable `payload` to exchange data.
 *
 * The `type` field typically follows the format `"<category>:<action>"`, where:
 * - `category` groups messages by functional domain.
 * - `action` identifies the specific message type within that category.
 *
 * Example:
 *  - A message with type `dev:cmdin` indicates a backstage command input sent from the client.
 *    Likewise, the `dev:cmdout` represents a response from the server.
 *  - A message with type `webchat:in` may indicate a message sent by client from a web-based chat system.
 */
@Serializable
data class WebSocketMessage(
    val type: String,
    val payload: JsonElement,
)

/**
 * Contains various types of websocket message for communication between client and server.
 */
object WebSocketMessageType {
    const val CMD_INPUT = "dev:cmdin"
    const val CMD_OUTPUT = "dev:cmdout"
    const val ERROR = "error"
}

/**
 * WebSocket utility to send a websocket response.
 *
 * Response will be formatted in JSON and transmitted in [Frame.Text] form.
 * The repsonse will also be logged.
 *
 * @param type The type of this websocket message. Use [WebSocketMessageType].
 * @param payload The payload of the message in [JsonElement].
 * @return Websocket's response in [Frame.Text].
 */
suspend fun DefaultWebSocketServerSession.respond(type: String, payload: JsonElement) {
    Fancam.debug(Tags.Websocket) {
        buildString {
            appendLine("##### [WebSocket Send]")
            appendLine("$INDENT type       : $type")
            append("$INDENT payload    : $payload")
        }
    }

    send(Frame.Text(JSON.encode(WebSocketMessage(type, payload))))
}
