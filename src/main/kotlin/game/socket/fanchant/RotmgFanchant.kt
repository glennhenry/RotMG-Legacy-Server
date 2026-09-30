package game.socket.fanchant

import encore.network.fanchant.Fanchant
import game.utils.autoToString
import java.io.DataInputStream

/**
 * Representation of [Fanchant] for RotMG network messages.
 * - [readBytes]: provides a [DataInputStream] to read the received network payload.
 * - [write]: implement optionally for message intended to be sent to client.
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

    /**
     * Pack this message accordingly into bytes to be sent to client.
     */
    fun write(): ByteArray
}
