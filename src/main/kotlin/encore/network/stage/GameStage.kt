package encore.network.stage

import encore.fancam.Fancam
import encore.fancam.INDENT
import encore.fancam.Tags
import encore.network.fanchant.Fanchant
import encore.network.fanchant.FanchantCoordinator
import encore.network.fanchant.guide.AllRounderFanchantGuide
import encore.network.fanchant.guide.DecodeResult
import encore.network.fanchant.guide.FanchantGuide
import encore.network.fanchant.guide.FanchantGuideRegistry
import encore.network.handler.FanchantHandler
import encore.network.handler.HandlerContext
import encore.network.lifecycle.PlayerLifecycle
import encore.network.lifecycle.PlayerLifecycleHandler
import encore.network.transport.Connection
import encore.network.transport.DefaultConnection
import encore.utils.hexString
import encore.utils.safeAsciiString
import encore.utils.support.className
import game.context.ServerContext
import io.ktor.network.selector.*
import io.ktor.network.sockets.*
import io.ktor.utils.io.*
import kotlinx.coroutines.*
import kotlinx.coroutines.CancellationException
import kotlin.system.measureTimeMillis

/**
 * The [Stage] implementation handling TCP socket connections used for main gameplay.
 *
 * @property host Server host configuration.
 * @property port Server port configuration.
 * @property initBlock DSL initialization block for registering
 *                     player lifecycle hooks, fanchant guides, and handlers.
 */
class GameStage(
    private val host: String,
    private val port: Int,
    private val initBlock: GameStageInitContext.() -> Unit
) : Stage {
    private lateinit var gameStageScope: CoroutineScope
    private lateinit var serverContext: ServerContext
    private lateinit var serverSocket: ServerSocket

    private val fanchantGuideRegistry = FanchantGuideRegistry()
    private val fanchantCoordinator = FanchantCoordinator()

    private var running = false

    override suspend fun initialize(scope: CoroutineScope, context: ServerContext) {
        this.gameStageScope = scope
        this.serverContext = context
        initBlock(
            GameStageInitContext(
                context.playerLifecycleHandler,
                fanchantCoordinator,
                fanchantGuideRegistry
            )
        )
    }

    override suspend fun start() {
        if (running) {
            Fancam.warn(Tags.Socket) { "GameStage.start() when it's already running, ignoring." }
            return
        }
        running = true

        this.serverSocket = bind()
        listenForConnections(serverSocket)
        Fancam.info(Tags.Socket) { "Game stage is listening on ($host:$port)" }
    }

    private suspend fun bind(): ServerSocket {
        val selectorManager = SelectorManager(Dispatchers.IO)
        val serverSocket = aSocket(selectorManager).tcp().bind(host, port)
        return serverSocket
    }

    private fun listenForConnections(serverSocket: ServerSocket) {
        gameStageScope.launch(Dispatchers.IO) {
            try {
                while (isActive) {
                    val socket = serverSocket.accept()
                    val connectionScope = CoroutineScope(SupervisorJob() + Dispatchers.Default)
                    val connection = DefaultConnection(
                        inputChannel = socket.openReadChannel(),
                        outputChannel = socket.openWriteChannel(autoFlush = true),
                        remoteAddress = socket.remoteAddress.toString(),
                        onSend = { serverContext.playerLifecycleHandler.onSend(serverContext, it) },
                        connectionScope = connectionScope
                    )
                    activateConnection(connection)
                }
            } catch (_: CancellationException) {
                Fancam.info(Tags.Socket) { "Game stage coroutine cancellation (shutdown)" }
            } catch (e: Exception) {
                Fancam.error(e, Tags.Socket) { "Scandal on game stage..." }
            } finally {
                serverSocket.close()
            }
        }
    }

    suspend fun activateConnection(connection: Connection) {
        Fancam.info(Tags.Socket) { "New $connection" }
        serverContext.playerLifecycleHandler.onConnect(serverContext, connection)
        processConnection(connection)
    }

    /**
     * Handle client [Connection] in suspending manner until data is available.
     */
    fun processConnection(connection: Connection) {
        connection.connectionScope.launch {
            try {
                loop@ while (isActive) {
                    val (bytesRead, data) = connection.read()
                    if (bytesRead <= 0) break@loop

                    serverContext.playerLifecycleHandler.onReceive(serverContext, connection)

                    // start handle
                    var fanchantType = "[Undetermined]"
                    val elapsed = measureTimeMillis {
                        fanchantType = handleFanchant(connection, data)
                    }

                    // end handle
                    Fancam.debug(Tags.Socket) {
                        buildString {
                            appendLine("<===== [SOCKET END]")
                            appendLine("$INDENT type      : $fanchantType")
                            appendLine("$INDENT identity  : ${connection.identity}")
                            appendLine("$INDENT duration  : ${elapsed}ms")
                            append("====================================================================================================")
                        }
                    }
                }
            } catch (e: CancellationException) {
                Fancam.trace(Tags.Socket) { "Coroutine cancelled for $connection: ${e.message}" }
            } catch (e: ClosedByteChannelException) {
                Fancam.trace(Tags.Socket) { "Connection closed for $connection: ${e.message}" }
            } catch (e: Exception) {
                Fancam.error(e, Tags.Socket) { "Scandal in $connection" }
            } finally {
                serverContext.playerLifecycleHandler.onDisconnect(serverContext, connection)
                connection.shutdown()
            }
        }
    }

    /**
     * Handle network message [data] in raw bytes received from [Connection] by:
     *
     * 1. Identify the [FanchantGuide] by calling [FanchantGuide.verify].
     * 2. Try to decode the format with [FanchantGuide.tryDecode].
     * 3. Call [FanchantGuide.materialize] into a high-level [Fanchant].
     * 4. Dispatch to the registered fanchant handlers.
     *
     * **Note**: By this architecture, it's possible for a single packet to be
     * successfully decoded by multiple fanchant guides. This situation is
     * inherently ambiguous. In such cases, the first successful decoding
     * result is selected, and a warning is logged.
     *
     * @return The specific fanchant type where decode succeed.
     */
    private suspend fun handleFanchant(connection: Connection, data: ByteArray): String {
        // Empty data
        if (data.isEmpty()) {
            Fancam.debug(Tags.Socket) { "[SOCKET] Ignored empty data from connection=$connection" }
            return "[Empty data]"
        }

        Fancam.debug(Tags.Socket) {
            buildString {
                appendLine("=====> [SOCKET RECEIVE]")
                appendLine("$INDENT identity  : ${connection.identity}")
                appendLine("$INDENT bytes     : ${data.size}")
                appendLine("$INDENT raw       : ${data.safeAsciiString()}")
                append("$INDENT raw (hex) : ${data.hexString()}")
            }
        }

        val matched = mutableListOf<Pair<String, Fanchant>>()
        val possibleGuides = fanchantGuideRegistry.identify(data)

        // Find possible guide for this fanchant
        for (guide in possibleGuides) {
            try {
                val result = guide.tryDecode(data)

                if (result is DecodeResult.Success<*>) {
                    // Success decoding, convert to Fanchant
                    val fanchant = guide.materializeAny(result.value)

                    Fancam.debug(Tags.Socket) {
                        buildString {
                            appendLine("[SOCKET DECODE] -> success")
                            appendLine("$INDENT type   : ${fanchant.type}")
                            append("$INDENT guide  : ${guide.className()}")
                        }
                    }

                    matched += guide.className() to fanchant
                }
            } catch (e: Exception) {
                Fancam.error(e, Tags.Socket) { "Decode scandal in fanchant guide ${guide.className()}" }
            }
        }

        // Allow only one interpretation of the fanchant, if there is multiple
        val (chosenGuide, fanchant) = matched.firstOrNull()
            ?: run {
                val guide = allRounderFanchantGuide
                val chant = allRounderFanchant(data)
                Fancam.debug(Tags.Socket) {
                    buildString {
                        appendLine("[SOCKET DECODE] -> fallback")
                        appendLine("$INDENT type   : ${chant.type}")
                        append("$INDENT guide  : ${allRounderFanchantGuide.className()}")
                    }
                }

                guide to chant
            }

        if (matched.size > 1) {
            Fancam.warn(Tags.Socket) {
                buildString {
                    appendLine(
                        "Multiple fanchant guides decoded the same packet: " +
                                matched.joinToString { "${it.first}/type=${it.second.type}" }
                    )
                    append("$INDENT chosen: $chosenGuide/type=${fanchant.type}")
                }
            }
        }

        // Dispatch fanchant to handler
        val handler = fanchantCoordinator.findHandler(fanchant)
        val context = HandlerContext(
            connection = connection,
            fanchant = fanchant
        )

        if (!handler.expectedFanchantClass.isInstance(context.fanchant)) {
            error(
                buildString {
                    appendLine("Fanchant handler type mismatch")
                    appendLine("Handler         : ${handler.className()}")
                    appendLine("Handler expects : ${handler.expectedFanchantClass.qualifiedName}")
                    appendLine("Actual message  : ${context.fanchant::class.qualifiedName}")
                    appendLine("Fanchant type   : '${context.fanchant.type}'")
                    appendLine()
                    appendLine("> Ensure FanchantHandler<T> generic type matches the actual message class that the routing type is supposed to be.")
                    appendLine("> e.g., handler with 'login' fanchantType shouldn't declare 'T' as `MoveMessage` when it should be `LoginMessage`.")
                }
            )
        }

        @Suppress("UNCHECKED_CAST")
        handler as FanchantHandler<Fanchant>
        handler.handle(context)

        return fanchant.type
    }

    // when no other guide matches, uses AllRounderFanchantGuide
    private val allRounderFanchantGuide = AllRounderFanchantGuide()

    // which also produces an all rounder fanchant from its tryDecode
    // and materializeAny implementation
    private fun allRounderFanchant(data: ByteArray): Fanchant {
        return allRounderFanchantGuide.materializeAny(
            (allRounderFanchantGuide.tryDecode(data) as DecodeResult.Success)
                .value
        )
    }

    override suspend fun shutdown() {
        running = false
    }
}

/**
 * DSL context for registering:
 * - [PlayerLifecycleHandler.LifecycleHook] to [PlayerLifecycleHandler]
 * - [FanchantGuide] to [FanchantGuideRegistry]
 * - [FanchantHandler] to [FanchantCoordinator]
 *
 * during game stage initialization.
 */
class GameStageInitContext(
    private val lifecycleHandler: PlayerLifecycleHandler,
    private val fanchantCoordinator: FanchantCoordinator,
    private val fanchantGuideRegistry: FanchantGuideRegistry
) {
    fun hook(lifecycle: PlayerLifecycle, name: String, hook: suspend (ServerContext, Connection) -> Unit) {
        lifecycleHandler.register(lifecycle, name, hook)
    }

    fun guide(guide: FanchantGuide<*>) {
        fanchantGuideRegistry.register(guide)
    }

    fun handler(handler: FanchantHandler<*>) {
        fanchantCoordinator.register(handler)
    }
}
