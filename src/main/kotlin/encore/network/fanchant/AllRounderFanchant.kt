package encore.network.fanchant

import encore.network.fanchant.guide.AllRounderFanchantGuide

/**
 * [Fanchant] implementation for [AllRounderFanchantGuide].
 *
 * Behavior:
 * - [type] declares a fixed identifier "N/A" (type is not applicable here).
 * - [toString] returns the decoded data.
 */
class AllRounderFanchant(val decoded: String) : Fanchant {
    override val type: String = "N/A"
    override fun toString(): String = decoded
}
