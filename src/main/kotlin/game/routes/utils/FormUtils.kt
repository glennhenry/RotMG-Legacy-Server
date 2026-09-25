package game.routes.utils

import io.ktor.http.decodeURLQueryComponent

/**
 * Utility to convert the game's request payload into Kotlin map representation.
 *
 * 1. Decode URL query form.
 * 2. Convert the string into map.
 */
fun String.formBodyToMap(): Map<String, String> {
    return this.decodeURLQueryComponent().urlStringToMap()
}

/**
 * Convert URL form string into Kotlin map.
 *
 * Example:
 * ```
 * param1=value1&param2=value2
 *
 * {param1: value1, param2: value2}
 * ```
 */
fun String.urlStringToMap(): Map<String, String> {
    val result = mutableMapOf<String, String>()
    val params = this.split("&")
    for (param in params) {
        val (key, value) = param.split("=")
        result[key] = value
    }
    return result
}
