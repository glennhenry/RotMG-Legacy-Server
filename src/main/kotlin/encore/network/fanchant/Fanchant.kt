package encore.network.fanchant

import encore.network.handler.FanchantHandler

/**
 * `Fanchant` represents a high-level network message sent by a client
 * and processed by a [FanchantHandler].
 *
 * Implementations of `Fanchant` encapsulate decoded packet data and may
 * provide helper methods or domain-specific behavior required during
 * message handling.
 *
 * This interface serves as the boundary between low-level protocol decoding
 * and application-level message processing.
 *
 * Implementations may be:
 * - Generic message wrappers (loosely typed), or
 * - Strongly typed domain message, often organized as sealed hierarchies.
 *
 * Examples:
 * - A comma-delimited protocol may use a `CommaMessage` implementation that
 *   provides cursor-based accessors such as `nextValue()`.
 * - A JSON-based protocol may define a generic `JsonMessage` as a base type,
 *   with strongly typed subclasses like `LoginRequest`, `SearchQuery`, etc.
 */
interface Fanchant {
    /**
     * Logical identifier of this fanchant, which is also used for handler
     * dispatchment.
     *
     * This typically describe the purpose of the message.
     * It should be unique per-message, meaning each different
     * `Fanchant` type or any subclass of it associate the fanchant
     * with a different identifier.
     *
     * For example,
     * - `LoginMessage` with `"login"` type inheriting `GameFanchant`,
     *   which inherits `Fanchant`. This may be handled by `LoginHandler`
     *   which assigns `"login"` as the message type it handles.
     * - `MoveMessage` with `"move"` type inheriting `GameFanchant`.
     *   This may be handled by `MoveHandler` which assigns `"move"`.
     *
     * **Important**: all fanchant type should be different, regardless
     * if they are a different [Fanchant] implementation. This is because
     * dispatchment logic primarily rely on type.
     */
    val type: String

    /**
     * Returns a human-readable representation of this packet
     * for debugging and logging.
     */
    override fun toString(): String
}
