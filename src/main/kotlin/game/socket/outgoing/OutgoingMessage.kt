package game.socket.outgoing

import java.io.DataOutputStream
import game.domain.account.CreateSuccessMessage
import game.domain.data.WorldPosData

/**
 * Represent a server-sent message in the socket connection.
 *
 * This can be an entire message like [CreateSuccessMessage] or a sub-data
 * that is included in the message like [WorldPosData]
 *
 * - By the server, this is considered as an "outgoing" message to the client.
 * - By the client, this is considered as an "incoming" message from the server.
 *
 * Implementation defines how to package itself into bytes in [write].
 */
interface OutgoingMessage {
    /**
     * Package the message into bytes.
     *
     * This only writes the data section and does not include the envelope details.
     *
     * Typically this isn't called directly but by the utility [createMessage].
     */
    fun write(output: DataOutputStream)
}
