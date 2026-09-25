package encore.network.transport

import game.mongo.collection.PlayerId
import kotlinx.coroutines.CoroutineScope

/**
 * Represents an active client connection to the server.
 *
 * `Connection` acts as the transport layer between the server and a client.
 * It encapsulates the underlying communication mechanism and provides APIs
 * for reading incoming data and writing outgoing data.
 *
 * A connection is initially unidentified and typically goes through an
 * authentication or handshake process before being recognized as a valid user.
 * Once identified, the connection's identity should be updated to reflect
 * the authenticated user.
 *
 * Each connection also provides a lightweight key-value storage for
 * temporary runtime data associated with the client. This storage is intended
 * for short-lived state that only exists for the lifetime of the connection.
 *
 * Data stored here should generally be small and non-persistent, as it is
 * discarded when the connection closes. Typical use cases include temporary
 * registration state, session-scoped gameplay data, or other transient values
 * that do not justify a dedicated server-side component.
 *
 * Implementations of this interface are responsible for:
 * - Reading and writing data through the underlying transport
 *   (e.g. TCP sockets, WebSockets, or virtual connections).
 * - Managing connection identity and authentication state.
 * - Providing temporary per-connection key-value storage.
 */
interface Connection {
    /**
     * The coroutine scope for this connection.
     */
    val connectionScope: CoroutineScope

    /**
     * Identity information.
     */
    val identity: ConnectionIdentity

    /**
     * Returns whether this connection is identified as a valid player in the server.
     */
    fun isIdentified(): Boolean

    /**
     * Shorthand for [ConnectionIdentity.playerId]
     */
    val playerId: PlayerId get() = identity.playerId ?: UndeterminedIdentity

    /**
     * Shorthand for [ConnectionIdentity.username]
     */
    val username: String get() = identity.username ?: UndeterminedIdentity

    /**
     * Shorthand for [ConnectionIdentity.remoteAddress]
     */
    val address: String get() = identity.remoteAddress

    /**
     * Update this connection's identity information.
     */
    fun updateIdentity(playerId: PlayerId, username: String)

    /**
     * Update this connection's [playerId].
     */
    fun updatePlayerId(playerId: PlayerId)

    /**
     * Update this connection's [username].
     */
    fun updateUsername(username: String)

    /**
     * Reads data sent by the client.
     *
     * @return A [Pair] where the first element is the number of bytes read
     *         (or `-1` if the connection has ended), and the second element
     *         contains the raw bytes received.
     */
    suspend fun read(): Pair<Int, ByteArray>

    /**
     * Sends data to the client.
     *
     * @param input The raw serialized bytes to transmit.
     * @param logOutput Whether the output should be logged.
     * @param logFull Whether the log message should be full.
     */
    suspend fun write(input: ByteArray, logOutput: Boolean = true, logFull: Boolean = false)

    /**
     * Returns the value associated with [key], or `null` if no value exists.
     */
    fun get(key: String): Any?

    /**
     * Associates [value] with [key].
     *
     * If a value is already associated with the key, it is replaced.
     */
    fun put(key: String, value: Any)

    /**
     * Removes the value associated with [key], if present.
     */
    fun delete(key: String)

    /**
     * Removes all values stored in this connection's temporary storage.
     */
    fun clearStorage()

    /**
     * Closes the connection and performs clean-up.
     */
    suspend fun shutdown()

    /**
     * Returns a human-readable string representation of this connection
     * for logging and debugging purpose.
     */
    override fun toString(): String
}
