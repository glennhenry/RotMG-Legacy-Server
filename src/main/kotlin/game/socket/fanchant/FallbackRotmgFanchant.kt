package game.socket.fanchant

import encore.utils.hexString
import java.io.DataInputStream

/**
 * A fallback for unknown or unmade rotmg messages.
 * - [readBytes] reads the input bytes into a hex string.
 * - [bytes] provides the raw bytes of the data section.
 * - [toString] will return that hex string.
 */
class FallbackRotmgFanchant(private val messageId: Int) : RotmgFanchant {
    override val type: String = "<fallback-type>"
    private var hexStr = ""
    var bytes = byteArrayOf()

    override fun readBytes(bytes: DataInputStream) {
        this.bytes = bytes.readAllBytes()
        hexStr = this.bytes.hexString()
    }

    override fun write(): ByteArray {
        error("Fallback message is only used to receive unknown message")
    }

    override fun toString(): String {
        return "messageId=$messageId, bytes=$hexStr"
    }
}
