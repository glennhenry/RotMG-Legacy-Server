package game.utils

import kotlin.reflect.full.memberProperties

/**
 * A helper to provide automatic `toString` implementation for
 * non-data class classes.
 */
fun Any.autoToString(): String {
    val className = this::class.simpleName
    val properties = this::class.memberProperties
        .joinToString(", ") { "${it.name}=${it.getter.call(this)?.toStringSafe()}" }
    return "$className($properties)"
}

fun Any?.toStringSafe(): String {
    return when (this) {
        is Collection<*> -> this.joinToString()
        is ByteArray -> this.contentToString()
        else -> this.toString()
    }
}
