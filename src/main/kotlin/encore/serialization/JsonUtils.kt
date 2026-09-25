package encore.serialization

import kotlinx.serialization.ExperimentalSerializationApi
import kotlinx.serialization.InternalSerializationApi
import kotlinx.serialization.SerializationStrategy
import kotlinx.serialization.json.*
import kotlinx.serialization.serializer
import kotlin.reflect.full.memberProperties
import kotlin.reflect.full.primaryConstructor

/**
 * Parse a JSON string into a Kotlin map.
 */
fun parseJsonToMap(serializer: Json, jsonStr: String): Map<String, Any> {
    return try {
        val parsed = serializer.decodeFromString<JsonObject>(jsonStr)
        parsed.mapValues { (_, v) -> v.toAny() }
    } catch (e: Throwable) {
        e.printStackTrace()
        emptyMap()
    }
}

/**
 * Convert [JsonElement] into an [Any] type.
 */
fun JsonElement.toAny(): Any = when (this) {
    is JsonPrimitive -> {
        when {
            this.isString -> this.content
            this.booleanOrNull != null -> this.boolean
            this.intOrNull != null -> this.int
            this.longOrNull != null -> this.long
            this.doubleOrNull != null -> this.double
            else -> this.content
        }
    }

    is JsonObject -> this.mapValues { it.value.toAny() }
    is JsonArray -> this.map { it.toAny() }
}

/**
 * Convert a map to [JsonObject] representation.
 */
fun Map<String, Any>?.toJsonObject(): JsonObject {
    return buildJsonObject {
        this@toJsonObject?.forEach { (key, value) ->
            put(key, value.toJsonElement())
        }
    }
}

/**
 * Convert `Any?` type to [JsonElement].
 *
 * @param useReflection Whether to use reflection to convert the object into
 *                      a full JSON graph. Without this, any unserializable object
 *                      (i.e., without `@Serializable` annotation) will fallback
 *                      to `toString()`.
 */
@OptIn(ExperimentalSerializationApi::class, InternalSerializationApi::class)
fun Any?.toJsonElement(useReflection: Boolean = false, visited: MutableSet<Int> = mutableSetOf()): JsonElement {
    val id = System.identityHashCode(this)
    if (this != null && !visited.add(id)) {
        return JsonPrimitive("<cycle>")
    }

    return when (this) {
        null -> JsonNull
        is String -> JsonPrimitive(this)
        is Number -> JsonPrimitive(this)
        is Boolean -> JsonPrimitive(this)
        is Map<*, *> -> buildJsonObject {
            this@toJsonElement.forEach { (k, v) ->
                put(k.toString(), v.toJsonElement(useReflection, visited))
            }
        }

        is Iterable<*> -> buildJsonArray {
            this@toJsonElement.forEach {
                add(
                    it.toJsonElement(
                        useReflection,
                        visited
                    )
                )
            }
        }

        is Pair<*, *> -> buildJsonObject {
            put("first", first.toJsonElement(useReflection, visited))
            put("second", second.toJsonElement(useReflection, visited))
        }

        is Triple<*, *, *> -> buildJsonObject {
            put("first", first.toJsonElement(useReflection, visited))
            put("second", second.toJsonElement(useReflection, visited))
            put("third", third.toJsonElement(useReflection, visited))
        }

        else -> {
            if (useReflection) {
                reflectToJson(this, true, visited)
            } else {
                val kClass = this::class
                val serializer = runCatching {
                    JSON.json.serializersModule.getContextual(kClass) ?: kClass.serializer()
                }.getOrNull()

                when {
                    serializer != null -> {
                        @Suppress("UNCHECKED_CAST")
                        JSON.json.encodeToJsonElement(serializer as SerializationStrategy<Any>, this)
                    }

                    else -> {
                        JsonPrimitive(this.toString())
                    }
                }
            }
        }
    }.also {
        if (this != null) {
            visited.remove(id)
        }
    }
}

fun reflectToJson(
    obj: Any,
    useReflection: Boolean,
    visited: MutableSet<Int>
): JsonElement {
    val kClass = obj::class
    val propsByName = kClass.memberProperties.associateBy { it.name }
    val ctorParams = kClass.primaryConstructor?.parameters

    return buildJsonObject {
        if (ctorParams != null) {
            for (param in ctorParams) {
                val name = param.name ?: continue
                val prop = propsByName[name] ?: continue

                val value = runCatching { prop.getter.call(obj) }.getOrNull()
                put(name, value.toJsonElement(useReflection, visited))
            }
        } else {
            propsByName.forEach { (name, prop) ->
                val value = runCatching { prop.getter.call(obj) }.getOrNull()
                put(name, value.toJsonElement(useReflection, visited))
            }
        }
    }
}
