package encore.network.lifecycle

import game.context.PlayerContext
import game.context.ServerContext
import encore.fancam.Fancam
import encore.fancam.Tags
import encore.network.transport.Connection
import encore.network.stage.GameStage

/**
 * Dispatches hooks for [PlayerLifecycle] events.
 *
 * Callers can register hooks via [register], which will be invoked on:
 * - [PlayerLifecycle.OnConnect]
 * - [PlayerLifecycle.OnIdentified]
 * - [PlayerLifecycle.OnContextCreated]
 * - [PlayerLifecycle.OnDisconnect]
 * - [PlayerLifecycle.OnSend]
 * - [PlayerLifecycle.OnReceive]
 *
 * Execution semantics:
 * - Hooks are invoked in the order they are registered.
 * - Each hook runs *after* the corresponding lifecycle event has completed:
 *     - `OnConnect`: after the player is connected
 *     - `OnIdentified`: after the player is identified as a valid player in the server
 *     - `OnContextCreated`: after [PlayerContext] is created for the player
 *     - `OnDisconnect`: after the player is disconnected
 *     - `OnSend`: after a message is sent
 *     - `OnReceive`: after a non-empty message is received
 *
 * Every hook is called by [GameStage] except for `OnIdentified` and `OnContextCreated`
 * where it's the user/application responsibility to call it.
 *
 * This component serves as an extension point over the connection lifecycle.
 * Hooks typically contains side-effect and not domain logic or handling.
 *
 * Typical use cases include:
 * - Updating player activity timestamps
 * - Marking players online/offline on connect/disconnect
 * - Notifying other players if their friend is now online
 * - Re-running server tasks
 */
class PlayerLifecycleHandler(private val logEachHook: Boolean = true) {
    /**
     * Hook of player lifecycle, provides [ServerContext]
     * and the associated player's [Connection].
     */
    typealias LifecycleHook = suspend (ServerContext, Connection) -> Unit

    private val onConnectHooks = mutableMapOf<String, LifecycleHook>()
    private val onIdentifiedHooks = mutableMapOf<String, LifecycleHook>()
    private val onContextCreatedHooks = mutableMapOf<String, LifecycleHook>()
    private val onDisconnectHooks = mutableMapOf<String, LifecycleHook>()
    private val onSendHooks = mutableMapOf<String, LifecycleHook>()
    private val onReceiveHooks = mutableMapOf<String, LifecycleHook>()

    /**
     * Register the [hook] identified by [name] for the [lifecycle].
     *
     * @param lifecycle The specific lifecycle that the hook is for.
     * @param name Human-readable identifier for debugging purpose.
     * @param hook The hook to be invoked.
     */
    fun register(lifecycle: PlayerLifecycle, name: String, hook: LifecycleHook) {
        when (lifecycle) {
            PlayerLifecycle.OnConnect -> onConnectHooks[name] = hook
            PlayerLifecycle.OnIdentified -> onIdentifiedHooks[name] = hook
            PlayerLifecycle.OnContextCreated -> onContextCreatedHooks[name] = hook
            PlayerLifecycle.OnDisconnect -> onDisconnectHooks[name] = hook
            PlayerLifecycle.OnSend -> onSendHooks[name] = hook
            PlayerLifecycle.OnReceive -> onReceiveHooks[name] = hook
        }
    }

    /**
     * Represent the [PlayerLifecycle.OnConnect] event for [connection].
     */
    suspend fun onConnect(serverContext: ServerContext, connection: Connection) {
        if (logEachHook) Fancam.trace(Tags.Lifecycle) { "onConnect lifecycle for '${connection.identity}'" }
        for ((name, hook) in onConnectHooks) {
            try {
                hook(serverContext, connection)
                if (logEachHook) Fancam.trace(Tags.Lifecycle) { "onConnect '$name' executed" }
            } catch (e: Exception) {
                Fancam.error(e, Tags.Lifecycle) { "onConnect '$name' scandal for '${connection.identity}'" }
            }
        }
    }


    /**
     * Represent the [PlayerLifecycle.OnIdentified] event for [connection].
     */
    suspend fun onIdentified(serverContext: ServerContext, connection: Connection) {
        if (logEachHook) Fancam.trace(Tags.Lifecycle) { "onIdentified lifecycle for '${connection.identity}'" }
        for ((name, hook) in onIdentifiedHooks) {
            try {
                hook(serverContext, connection)
                if (logEachHook) Fancam.trace(Tags.Lifecycle) { "onIdentified '$name' executed" }
            } catch (e: Exception) {
                Fancam.error(e, Tags.Lifecycle) { "onIdentified '$name' scandal for '${connection.identity}'" }
            }
        }
    }

    /**
     * Represent the [PlayerLifecycle.OnContextCreated] event for [connection].
     */
    suspend fun onContextCreated(serverContext: ServerContext, connection: Connection) {
        if (logEachHook) Fancam.trace(Tags.Lifecycle) { "onContextCreated lifecycle for '${connection.identity}'" }
        for ((name, hook) in onContextCreatedHooks) {
            try {
                hook(serverContext, connection)
                if (logEachHook) Fancam.trace(Tags.Lifecycle) { "onContextCreated '$name' executed" }
            } catch (e: Exception) {
                Fancam.error(e, Tags.Lifecycle) { "onContextCreated '$name' scandal for '${connection.identity}'" }
            }
        }
    }

    /**
     * Represent the [PlayerLifecycle.OnDisconnect] event for [connection].
     */
    suspend fun onDisconnect(serverContext: ServerContext, connection: Connection) {
        if (logEachHook) Fancam.trace(Tags.Lifecycle) { "onDisconnect lifecycle for '${connection.identity}'" }
        for ((name, hook) in onDisconnectHooks) {
            try {
                hook(serverContext, connection)
                if (logEachHook) Fancam.trace(Tags.Lifecycle) { "onDisconnect '$name' executed" }
            } catch (e: Exception) {
                Fancam.error(e, Tags.Lifecycle) { "onDisconnect '$name' scandal for '${connection.identity}'" }
            }
        }
    }

    /**
     * Represent the [PlayerLifecycle.OnSend] event for [connection].
     */
    suspend fun onSend(serverContext: ServerContext, connection: Connection) {
        if (logEachHook) Fancam.trace(Tags.Lifecycle) { "onSend lifecycle for '${connection.identity}'" }
        for ((name, hook) in onSendHooks) {
            try {
                hook(serverContext, connection)
                if (logEachHook) Fancam.trace(Tags.Lifecycle) { "onSend '$name' executed" }
            } catch (e: Exception) {
                Fancam.error(e, Tags.Lifecycle) { "onSend '$name' scandal for '${connection.identity}'" }
            }
        }
    }

    /**
     * Represent the [PlayerLifecycle.OnReceive] event for [connection].
     */
    suspend fun onReceive(serverContext: ServerContext, connection: Connection) {
        if (logEachHook) Fancam.trace(Tags.Lifecycle) { "onReceive lifecycle for '${connection.identity}'" }
        for ((name, hook) in onReceiveHooks) {
            try {
                hook(serverContext, connection)
                if (logEachHook) Fancam.trace(Tags.Lifecycle) { "onReceive '$name' executed" }
            } catch (e: Exception) {
                Fancam.error(e, Tags.Lifecycle) { "onReceive '$name' scandal for '${connection.identity}'" }
            }
        }
    }
}
