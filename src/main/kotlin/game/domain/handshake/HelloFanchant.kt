package game.domain.handshake

import game.socket.RSAUtils
import game.socket.fanchant.RotmgFanchant
import game.utils.autoToString
import java.io.DataInputStream

/**
 * Represent the `Hello` message sent by client.
 */
class HelloFanchant(messageId: Int) : RotmgFanchant {
    override val type: String = messageId.toString()

    var buildVersion: String = ""
    var gameId: Int = 0
    var guid: String = ""
    var random1: Int = 0
    var random2: Int = 0
    var password: String = ""
    var secret: String = ""
    var keyTime: Int = 0
    var key: ByteArray = byteArrayOf()
    var mapJSON: String = ""
    var entryTag: String = ""
    var gameNet: String = ""
    var gameNetUserId: String = ""
    var playPlatform: String = ""
    var platformToken: String = ""

    override fun readBytes(bytes: DataInputStream) {
        buildVersion = bytes.readUTF()
        gameId = bytes.readInt()
        guid = RSAUtils.decrypt(bytes.readUTF())
        random1 = bytes.readInt()
        password = bytes.readUTF()
        random2 = bytes.readInt()
        secret = bytes.readUTF()
        keyTime = bytes.readInt()
        val keyLength = bytes.readShort().toInt()
        key = bytes.readNBytes(keyLength)
        val mapJsonLength = bytes.readInt()
        mapJSON = String(bytes.readNBytes(mapJsonLength))
        entryTag = bytes.readUTF()
        gameNet = bytes.readUTF()
        gameNetUserId = bytes.readUTF()
        playPlatform = bytes.readUTF()
        platformToken = bytes.readUTF()
    }

    override fun write(): ByteArray {
        error("Hello message is a client-sent message.")
    }

    override fun toString(): String {
        return this.autoToString()
    }
}
