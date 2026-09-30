package game.utils

import kotlin.reflect.full.memberProperties

/**
 * A helper to provide automatic `toString` implementation for
 * non-data class classes.
 */
fun Any.autoToString(): String {
    val className = this::class.simpleName
    val properties = this::class.memberProperties
        .joinToString(", ") { "${it.name}=${it.getter.call(this)}" }
    return "$className($properties)"
}
