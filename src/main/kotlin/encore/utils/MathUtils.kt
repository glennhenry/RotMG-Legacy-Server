package encore.utils

import com.toxicbakery.bcrypt.Bcrypt
import kotlin.io.encoding.Base64

/**
 * Converts [this] amount of MB into bytes.
 *
 * e.g., `3.toMB()` is equals to approximately `3_000_000` bytes.
 */
fun Int.mbToBytes(): Long = this * 1024L * 1024L

/**
 * Hash the given [s] string using the Bcrypt function
 * with the specified salt [rounds].
 *
 * @return Hashed string in Base64 representation.
 */
fun hash(s: String, rounds: Int = 10): String {
    return Base64.encode(Bcrypt.hash(s, rounds))
}
