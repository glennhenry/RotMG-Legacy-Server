package encore.serialization

import encore.fancam.Fancam
import encore.fancam.Tags
import encore.serialization.JSON.initialize
import kotlinx.serialization.DeserializationStrategy
import kotlinx.serialization.SerializationStrategy
import kotlinx.serialization.json.Json

/**
 * Global JSON serialization helper, intended to provide a serialization operation
 * from a single shared [Json] configuration.
 *
 * This must be initialized via [initialize] before use.
 */
object JSON {
    private var _json: Json? = null
    val json: Json
        get() = _json ?: error("JSON is not initialized. Call JSON.initialize() first.")

    fun initialize(json: Json) {
        if (_json != null) {
            Fancam.warn(Tags.Json) { "JSON.initialize() called after initialization. Ignoring." }
            return
        }
        this._json = json
    }

    inline fun <reified T> encode(value: T): String {
        return json.encodeToString<T>(value)
    }

    inline fun <reified T> encode(serializer: SerializationStrategy<T>, value: T): String {
        return json.encodeToString(serializer, value)
    }

    inline fun <reified T> decode(value: String): T {
        return json.decodeFromString<T>(value)
    }

    inline fun <reified T> decode(deserializer: DeserializationStrategy<T>, value: String): T {
        return json.decodeFromString(deserializer, value)
    }
}
