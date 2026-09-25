package encore.network.fanchant.guide

import encore.fancam.Fancam
import encore.fancam.Tags
import encore.utils.support.className

/**
 * Contains every [FanchantGuide]s supported by the server.
 *
 * The registry is responsible for:
 * - Keeping track of registered fanchant guides.
 * - Identifying which guides *may* match a given raw byte sequence.
 * - Providing a safe fallback when no guide matches.
 */
class FanchantGuideRegistry {
    private val formats = mutableListOf<FanchantGuide<*>>()

    /**
     * Registers a [FanchantGuide].
     */
    fun register(format: FanchantGuide<*>) {
        formats.add(format)
    }

    /**
     * Identifies fanchant guide that *may* correspond to the raw byte
     * sequence [data].
     *
     * This method applies only the lightweight [FanchantGuide.verify]
     * check and does not perform full decoding.
     *
     * Verification errors are caught and logged to prevent malformed or
     * experimental formats from disrupting format detection.
     *
     * @return A non-empty list of candidate [FanchantGuide]s that may match the data.
     *         If no formats match, a fallback [AllRounderFanchantGuide] is returned.
     */
    fun identify(data: ByteArray): List<FanchantGuide<*>> {
        val matched = mutableListOf<FanchantGuide<*>>()

        for (format in formats) {
            try {
                if (format.verify(data)) {
                    matched.add(format)
                }
            } catch (e: Exception) {
                Fancam.warn(Tags.Fanchant) {
                    val peek = data.copyOfRange(0, minOf(20, data.size))
                    "${format.className()} verify scandal; peek=${peek.contentToString()}; scandal=${e.message}"
                }
            }
        }

        return matched
    }
}
