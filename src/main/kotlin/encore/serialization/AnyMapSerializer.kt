package encore.serialization

import kotlinx.serialization.KSerializer
import kotlinx.serialization.builtins.MapSerializer
import kotlinx.serialization.builtins.serializer
import kotlinx.serialization.descriptors.SerialDescriptor
import kotlinx.serialization.encoding.Decoder
import kotlinx.serialization.encoding.Encoder
import kotlinx.serialization.json.*

/**
 * Serialize `Map<String, Any>` to JSON in a strict manner,
 * where every fields are transformed into `JSONElement`.
 *
 * Must annotate custom type with `@Serializable` for serialization to work nestedly.
 */
object AnyMapSerializer : KSerializer<Map<String, Any>> {
    override val descriptor: SerialDescriptor =
        MapSerializer(String.serializer(), JsonElement.serializer()).descriptor

    @Suppress("UNCHECKED_CAST")
    override fun serialize(encoder: Encoder, value: Map<String, Any>) {
        val jsonEncoder = encoder as? JsonEncoder
            ?: error("This serializer only works with JSON")
        val converted = value.mapValues { (_, v) -> v.toJsonElement() }
        jsonEncoder.encodeJsonElement(JsonObject(converted))
    }

    override fun deserialize(decoder: Decoder): Map<String, Any> {
        val jsonDecoder = decoder as? JsonDecoder
            ?: error("This serializer only works with JSON")
        val obj = jsonDecoder.decodeJsonElement().jsonObject
        return obj.mapValues { it.value }
    }
}
