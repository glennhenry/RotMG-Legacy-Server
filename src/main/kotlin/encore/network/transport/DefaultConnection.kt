package encore.network.transport

import encore.acts.StageAct
import game.mongo.collection.PlayerId
import encore.fancam.Fancam
import encore.fancam.INDENT
import encore.fancam.Tags
import encore.fancam.events.Level
import encore.utils.hexString
import encore.utils.safeAsciiString
import io.ktor.utils.io.*
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.cancel
import kotlinx.coroutines.job
import kotlin.coroutines.cancellation.CancellationException

/**
 * Default implementation of [Connection] which is based on a real socket.
 *
 * Uses the [ByteReadChannel] and [ByteWriteChannel].
 */
class DefaultConnection(
    private val inputChannel: ByteReadChannel,
    private val outputChannel: ByteWriteChannel,
    private val remoteAddress: String,
    private val onSend: suspend (Connection) -> Unit,
    override val connectionScope: CoroutineScope
) : Connection {
    override val identity: ConnectionIdentity = ConnectionIdentity(remoteAddress = remoteAddress)
    private val storage = mutableMapOf<String, Any>()

    /**
     * Suspends until data becomes available on the input channel,
     * then reads it into a buffer.
     *
     * @return A [Pair] containing:
     *   - The number of bytes successfully read, or `-1` if the stream has ended.
     *   - A [ByteArray] containing the data that was read.
     */
    override suspend fun read(): Pair<Int, ByteArray> {
        val buffer = ByteArray(4096)
        val bytesRead = inputChannel.readAvailable(buffer, 0, buffer.size)
        if (bytesRead <= 0) return -1 to byteArrayOf()
        return bytesRead to buffer.copyOfRange(0, bytesRead)
    }

    /**
     * Send bytes [input] to client.
     *
     * No modification is done to the byte array is done.
     * Serialization must be done manually.
     */
    override suspend fun write(input: ByteArray, logOutput: Boolean, logFull: Boolean) {
        try {
            if (logOutput) {
                Fancam.event(Level.Debug, Tags.Socket)
                    .message {
                        buildString {
                            appendLine("[SOCKET SEND]")
                            appendLine("$INDENT raw       : ${input.safeAsciiString()}")
                            append("$INDENT raw (hex) : ${input.hexString()}")
                        }
                    }
                    .log(full = logFull)
            }
            outputChannel.writeFully(input)
            if (logOutput) {
                onSend(this)
            }
        } catch (_: ClosedWriteChannelException) {
        } catch (e: Exception) {
            Fancam.error(e, Tags.Socket) { "Failed to write to $this" }
            throw e
        }
    }

    /**
     * Player is identified when their playerId is not null.
     */
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

    /**
     * Shutdown the connection which cancels the [connectionScope].
     *
     * By structured concurrency, this would also cancel every coroutine work
     * associated with the scope, which includes server-sided [StageAct]s.
     */
    override suspend fun shutdown() {
        try {
            clearStorage()
            connectionScope.cancel(CancellationException("Connection closed"))
            connectionScope.coroutineContext.job.join()
        } catch (_: ClosedWriteChannelException) {
            // connection is closed during write
        } catch (_: CancellationException) {
            // connection is closed
        } catch (e: Exception) {
            Fancam.warn(Tags.Socket) { "Scandal during connection shutdown: ${e.message}" }
        }
    }

    override fun toString(): String {
        return "Connection(${this.identity})"
    }
}
