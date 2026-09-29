package encore.network.fanchant.guide

import encore.network.fanchant.Fanchant
import encore.network.fanchant.AllRounderFanchant

/**
 * A fallback-based implementation of [FanchantGuide].
 *
 * This guide focuses on catching all unknown or unsupported message.
 * It guarantees that any incoming packet is always produced and reported.
 * It will only be used when no other `FanchantGuide` are able to decode successfully.
 *
 * Behavior:
 * - [verify] always returns `true`.
 * - [tryDecode] always succeeds, raw bytes are returned as-is.
 * - [materialize] wraps the decoded string into a [AllRounderFanchant].
 */
class AllRounderFanchantGuide : FanchantGuide<ByteArray> {
    override fun verify(data: ByteArray): Boolean = true

    override fun tryDecode(data: ByteArray): DecodeResult<ByteArray> {
        return DecodeResult.Success(data)
    }

    override fun materialize(decoded: ByteArray): Fanchant {
        return AllRounderFanchant(decoded)
    }
}
