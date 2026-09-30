package encore.network.fanchant

import encore.network.fanchant.guide.AllRounderFanchantGuide
import encore.utils.safeAsciiString

/**
 * [Fanchant] implementation for [AllRounderFanchantGuide].
 *
 * Behavior:
 * - [type] declares a fixed identifier "N/A", or provide in constructor.
 * - [toString] returns an ascii-safe string of the bytes data.
 * - [bytes] to get the raw bytes data.
 */
class AllRounderFanchant(
    val bytes: ByteArray,
    override val type: String = "N/A"
) : Fanchant {
    override fun toString(): String = bytes.safeAsciiString()
}
