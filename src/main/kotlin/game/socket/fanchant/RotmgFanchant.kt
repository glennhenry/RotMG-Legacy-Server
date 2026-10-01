package game.socket.fanchant

import encore.network.fanchant.Fanchant
import game.utils.autoToString
import java.io.DataInputStream

/**
 * Representation of [Fanchant] for RotMG network messages.
 *
 * This is also known as:
 * - By the server, this is considered as an "incoming" message from the client.
 * - By the client, this is considered as an "outgoing" message to the server.
 *
 * - [readBytes]: provides a [DataInputStream] to read the received network payload.
 *
 * Implementation generally:
 * - Inherit this fanchant class instead of the root [Fanchant].
 * - Take a `messageId` from the constructor to implement [type].
 * - List every properties of the message. To obtain the list of properties,
 *   refer to client code.
 * - Inside [readBytes], parse the input byte array and populate every properties.
 * - May implement [toString] with [autoToString].
 */
interface RotmgFanchant : Fanchant {
    /**
     * Populate local properties of the fanchant from input [bytes].
     */
    fun readBytes(bytes: DataInputStream)
}
