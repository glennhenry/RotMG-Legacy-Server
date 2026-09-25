package encore.utils

import java.nio.charset.Charset

/**
 * Return whether this `ByteArray` starts with the [prefix] bytes.
 */
fun ByteArray.startsWithBytes(prefix: ByteArray): Boolean {
    if (this.size < prefix.size) return false
    for (i in prefix.indices) {
        if (this[i] != prefix[i]) return false
    }
    return true
}

/**
 * Return whether this `ByteArray` starts with the [prefix] string.
 */
fun ByteArray.startsWithString(prefix: String, charset: Charset = Charsets.UTF_8): Boolean {
    val prefixBytes = prefix.toByteArray(charset)
    if (this.size < prefixBytes.size) return false
    for (i in prefixBytes.indices) {
        if (this[i] != prefixBytes[i]) return false
    }
    return true
}

/**
 * Return an ASCII-only string representation of this `ByteArray`.
 *
 * This only includes characters within the ASCII range (32-126)
 * and replaces them with a specific character (default '?').
 *
 * For example:
 * ```
 * val text = "hello world 💀 123".toByteArray()
 * println(text.safeAsciiString()) // hello world ? 123
 * ```
 */
fun ByteArray.safeAsciiString(replaceWith: Char = '�'): String {
    val decoded = decodeToString()
    val sb = StringBuilder()
    var lastWasReplacement = false

    for (c in decoded) {
        if (c.code in 32..126) {
            sb.append(c)
            lastWasReplacement = false
        } else {
            if (!lastWasReplacement) {
                sb.append(replaceWith)
                lastWasReplacement = true
            }
        }
    }
    return sb.toString()
}

/**
 * Return a hex-based string of this `ByteArray`.
 *
 * For example:
 * ```
 * val bytes = byteArrayOf(0x01, 0x29, 0x4A, 0x68, 0x7E)
 * println(bytes.hexString()) // 01 29 4A 68 7E
 * ```
 */
fun ByteArray.hexString(): String {
    return joinToString(" ") { "%02X".format(it.toInt() and 0xFF) }
}
