package encore.network.fanchant.guide

import encore.network.fanchant.Fanchant

/**
 * Defines the decoding pipeline for a network message.
 *
 * A [FanchantGuide] describes how raw packet data is identified, decoded,
 * and transformed into a [Fanchant] instance suitable for handler dispatch.
 *
 * The decoding process consists of three stages:
 *
 * 1. [verify] performs a lightweight, permissive check to determine whether
 *    the provided byte sequence may belong to this guide.
 * 2. [tryDecode] attempts to fully decode the packet into an intermediate
 *    representation and may succeed or fail.
 * 3. [materialize] converts the decoded representation into a [Fanchant]
 *    instance used by the application layer.
 *
 * **Note:** In systems supporting multiple fanchant guides, it is acceptable
 * for multiple guides to correctly `verify` the same input. However, only one
 * guide should successfully decode it; multiple successful decodes
 * is treated as ambiguity and will be reported.
 *
 * See `test.kotlin.encoreTest.example.MessageFormat` for an implementation example.
 *
 * @param T The **intermediate decoded representation** produced during decoding.
 *          This is not the target [Fanchant] class it eventually produces in [materialize].
 */
interface FanchantGuide<T> {
    /**
     * Performs a cheap, permissive check to determine whether the raw byte
     * sequence [data] *may* conform to the fanchant described by this guide.
     *
     * Implementations must be fast and non-strict. False positives are
     * acceptable and expected.
     *
     * This method should not perform full decoding or heavy parsing.
     *
     * Examples:
     * - A JSON-based format may check whether the first byte is '{'
     *   and the last byte is '}'.
     * - A framed protocol may verify that the message length is consistent.
     * - A fixed-header protocol may check for the presence of a known
     *   header signature.
     */
    fun verify(data: ByteArray): Boolean

    /**
     * Attempts to fully decode the raw byte sequence [data].
     *
     * Decoding may fail even if [verify] returned true. Such failures
     * are considered normal and non-fatal.
     *
     * @return A [DecodeResult] indicating success or failure.
     */
    fun tryDecode(data: ByteArray): DecodeResult<T>

    /**
     * Converts the decoded intermediate representation into a concrete
     * [Fanchant] that can be dispatched to handlers.
     *
     * This step bridges protocol-level data with application-level
     * message semantics. Implementations may produce:
     * - A generic message wrapper, or
     * - A strongly typed, domain-specific message.
     *
     * This method works together with [materializeAny] which
     * contain an unchecked cast to bypass star projection.
     * This is safe if [decoded] is produced from [tryDecode].
     */
    fun materialize(decoded: T): Fanchant

    @Suppress("UNCHECKED_CAST")
    fun materializeAny(decoded: Any?): Fanchant {
        return materialize(decoded as T)
    }
}

/**
 * Represents the result of attempting to decode a message on a
 * [FanchantGuide].
 *
 * @param T The intermediary type of the successfully decoded message.
 */
sealed interface DecodeResult<out T> {
    /**
     * Indicates a successful decoding outcome.
     */
    data class Success<T>(val value: T) : DecodeResult<T>

    /**
     * Indicates that the decoding fails.
     *
     * @property reason Optional explanation for the failure.
     * @property error Optional underlying exception that caused the failure.
     */
    data class Failure(
        val reason: String? = null,
        val error: Throwable? = null
    ) : DecodeResult<Nothing>
}
