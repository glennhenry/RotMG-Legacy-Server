package encore.network.transport

import game.mongo.collection.PlayerId
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.delay
import kotlinx.coroutines.withContext
import kotlin.time.Duration.Companion.seconds

/**
 * Implementation of [Connection] which is used for testing purposes.
 *
 * This allows test code to inject incoming messages of raw bytes
 * and capture all outgoing writes.
 *
 * Example:
 * ```
 * val conn = TestConnection(
 *     connectionScope = CoroutineScope(StandardTestDispatcher()),
 *     playerId = "p1",
 *     playerName = "Alice"
 * )
 * conn.enqueueIncoming("Hello".toByteArray())
 *
 * val (_, bytes) = conn.read() // returns the injected message
 * assertEquals("Hello", String(bytes))
 *
 * conn.write("World".toByteArray())
 * assertEquals("World", String(conn.getOutgoing().first()))
 * ```
 *
 * Storage is also available to be provided directly via constructor.
 */
class TestConnection(
    override val identity: ConnectionIdentity,
    override val connectionScope: CoroutineScope,
    private val storage: MutableMap<String, Any> = mutableMapOf()
) : Connection {
    private val incoming = Channel<ByteArray>(Channel.UNLIMITED)
    private val writtenBytes = mutableListOf<ByteArray>()

    /**
     * Enqueue a raw [ByteArray] to be returned by [Connection.read].
     */
    fun enqueueIncoming(data: ByteArray) {
        incoming.trySend(data)
    }

    /**
     * Get the outgoing bytes which is written by [Connection.write].
     */
    fun getOutgoing(): List<ByteArray> {
        return writtenBytes
    }

    /**
     * To wait until outgoing is ready (non-empty) for one minute,
     * delaying every [timeoutInSeconds].
     */
    suspend fun awaitOutgoing(timeoutInSeconds: Int = 1) {
        withContext(Dispatchers.Default.limitedParallelism(1)) {
            while (getOutgoing().isEmpty()) {
                delay(timeoutInSeconds.seconds)
            }
        }
    }

    override suspend fun read(): Pair<Int, ByteArray> {
        val bytes = incoming.receiveCatching().getOrNull() ?: return -1 to byteArrayOf()
        return bytes.size to bytes
    }

    override suspend fun write(input: ByteArray, logOutput: Boolean, logFull: Boolean) {
        writtenBytes += input
    }

    override fun isIdentified(): Boolean {
        return identity.playerId != null
    }

    override fun updateIdentity(playerId: PlayerId, username: String) {
        identity.playerId = playerId
        identity.username = username
    }

    override fun updatePlayerId(playerId: PlayerId) {
        identity.playerId = playerId
    }

    override fun updateUsername(username: String) {
        identity.username = username
    }

    override fun get(key: String): Any? {
        return storage[key]
    }

    override fun put(key: String, value: Any) {
        storage[key] = value
    }

    override fun delete(key: String) {
        storage.remove(key)
    }

    override fun clearStorage() {
        storage.clear()
    }

    override suspend fun shutdown() {
        clearStorage()
        incoming.close()
    }

    override fun toString(): String = "TestConnection(${this.identity})"
}
