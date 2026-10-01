package game.socket.outgoing

import encore.network.transport.Connection
import java.io.ByteArrayOutputStream
import java.io.DataOutputStream

/**
 * A utility to create message to be sent in the socket.
 *
 * - Provide `messageId` and outgoing message representation.
 * - This will call [OutgoingMessage.write] to package the data.
 * - Wrap the data with envelope details.
 * - Return a ready-to-sent bytearray in [Connection].
 *
 * @param messageId `messageId`
 * @param outgoing [OutgoingMessage]
 */
fun createMessage(messageId: Int, outgoing: OutgoingMessage): ByteArray {
    // data section
    val dataStream = ByteArrayOutputStream()
    val dataOutput = DataOutputStream(dataStream)
    outgoing.write(dataOutput)
    dataOutput.flush()
    val dataSection = dataStream.toByteArray()

    // envelope
    val stream = ByteArrayOutputStream()
    val output = DataOutputStream(stream)

    // total length
    output.writeInt(dataSection.size + 5)

    // messageId
    output.writeByte(messageId)

    // data section
    output.write(dataSection)

    output.flush()
    return stream.toByteArray()
}
