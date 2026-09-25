package encore.serialization

import encore.fancam.Fancam
import encore.fancam.Tags
import kotlinx.serialization.*
import kotlinx.serialization.protobuf.ProtoBuf

/**
 * Global Protobuf serialization helper, intended to provide a serialization operation
 * from a single shared [ProtoBuf] configuration.
 *
 * This must be initialized via [initialize] before use.
 */
@OptIn(ExperimentalSerializationApi::class)
object Protobuf {
    private var _protoBuf: ProtoBuf? = null
    val protoBuf: ProtoBuf
        get() = _protoBuf ?: error("Protobuf is not initialized. Call Protobuf.initialize() first.")

    fun initialize(protoBuf: ProtoBuf) {
        if (_protoBuf != null) {
            Fancam.warn(Tags.Protobuf) { "Protobuf.initialize() called after initialization. Ignoring." }
            return
        }
        this._protoBuf = protoBuf
    }

    inline fun <reified T> encode(value: T): ByteArray {
        return protoBuf.encodeToByteArray<T>(value)
    }

    inline fun <reified T> encode(serializer: SerializationStrategy<T>, value: T): ByteArray {
        return protoBuf.encodeToByteArray(serializer, value)
    }

    inline fun <reified T> decode(value: ByteArray): T {
        return protoBuf.decodeFromByteArray<T>(value)
    }

    inline fun <reified T> decode(deserializer: DeserializationStrategy<T>, value: ByteArray): T {
        return protoBuf.decodeFromByteArray(deserializer, value)
    }
}
