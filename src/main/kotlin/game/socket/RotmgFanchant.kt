package game.socket

import encore.fancam.Fancam
import encore.fancam.INDENT
import encore.network.fanchant.Fanchant
import encore.network.fanchant.guide.DecodeResult
import encore.network.fanchant.guide.FanchantGuide
import encore.network.handler.FanchantHandler
import encore.network.handler.HandlerContext
import encore.utils.hexString
import encore.utils.toJsonString
import java.io.DataInputStream
import kotlin.reflect.KClass

class RotmgHandler : FanchantHandler<RotmgFanchant> {
    override val fanchantType: String = "1"
    override val expectedFanchantClass: KClass<RotmgFanchant> = RotmgFanchant::class

    override suspend fun handle(ctx: HandlerContext<RotmgFanchant>) = with(ctx) {

    }
}

class RotmgFancantGuide : FanchantGuide<Map<String, Any?>> {
    override fun verify(data: ByteArray): Boolean {
        return true
    }

    override fun tryDecode(data: ByteArray): DecodeResult<Map<String, Any?>> {
        return DecodeResult.Success(RotmgSerializer.decode(data))
    }

    override fun materialize(decoded: Map<String, Any?>): Fanchant {
        return RotmgFanchant(decoded)
    }
}

class RotmgFanchant(private val data: Map<String, Any?>) : Fanchant {
    override val type: String = "1"

    override fun toString(): String {
        return data.toJsonString(INDENT.length)
    }
}

object RotmgSerializer {
    fun decode(bytes: ByteArray): Map<String, Any?> {
        val input = DataInputStream(bytes.inputStream())

        val totalPayloadLength = input.readInt()
        val messageLength = totalPayloadLength - 5

        val messageId = input.readByte()
        val message = input.readNBytes(messageLength)

        Fancam.debug { "Got messageId: $messageId" }
        return decodeHello(message)
    }

    fun decodeHello(bytes: ByteArray): Map<String, Any?> {
        val input = DataInputStream(bytes.inputStream())
        val result = mutableMapOf<String, Any?>()

        result["buildVersion"] = input.readUTF()
        result["gameId"] = input.readInt()
        result["guid"] = RSAUtils.decrypt(input.readUTF())
        result["random1"] = input.readInt()
        result["password"] = input.readUTF()
        result["random2"] = input.readInt()
        result["secret"] = input.readUTF()
        result["keyTime"] = input.readInt()
        val keyLength = input.readShort().toInt()
        result["key"] = input.readNBytes(keyLength)
        val mapJsonLength = input.readInt()
        result["mapJSON"] = input.readNBytes(mapJsonLength)
        result["entryTag"] = input.readUTF()
        result["gameNet"] = input.readUTF()
        result["gameNetUserId"] = input.readUTF()
        result["playPlatform"] = input.readUTF()
        result["platformToken"] = input.readUTF()

        return result
    }

    fun encode() {}
}

