package encore.network.lifecycle

import game.context.PlayerContext

/**
 * Represent the lifecycle of player connection in the socket server.
 */
enum class PlayerLifecycle {
    /**
     * Player is connected to the socket server.
     */
    OnConnect,

    /**
     * Player is identified, typically through an authentication process.
     */
    OnIdentified,

    /**
     * [PlayerContext] is created for the player.
     */
    OnContextCreated,

    /**
     * Player is disconnected from the socket server.
     */
    OnDisconnect,

    /**
     * The socket server sends a message to the player.
     */
    OnSend,

    /**
     * The socket server receives a message from the player.
     */
    OnReceive
}
