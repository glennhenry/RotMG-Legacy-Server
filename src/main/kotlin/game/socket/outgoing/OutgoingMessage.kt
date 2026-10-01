package game.socket.outgoing

import java.io.DataOutputStream

/**
 * Represent a server-sent message in the socket connection.
 *
 * - By the server, this is considered as an "outgoing" message to the client.
 * - By the client, this is considered as an "incoming" message from the server.
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
