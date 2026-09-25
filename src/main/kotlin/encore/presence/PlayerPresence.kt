package encore.presence

import game.mongo.collection.PlayerId

/**
 * Represents the current presence status of a player.
 *
 * @property playerId Unique identifier of the player.
 * @property onlineSince The timestamp (in milliseconds since epoch)
 *                       when the player came online.
 * @property lastNetworkActivity The timestamp (in milliseconds since epoch)
 *                               of the player's most recent network activity.
 */
data class PlayerPresence(
    val playerId: PlayerId,
    val onlineSince: Long,
    @Volatile
    var lastNetworkActivity: Long
)
