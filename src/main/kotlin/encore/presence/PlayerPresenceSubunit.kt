package encore.presence

import game.mongo.collection.PlayerId
import encore.fancam.Fancam
import encore.fancam.Tags
import encore.network.transport.UndeterminedIdentity
import encore.subunit.Subunit
import encore.subunit.scope.ServerScope
import encore.time.TimeCenter
import java.util.concurrent.ConcurrentHashMap

/**
 * Server subunit for tracking players presence status.
 *
 * This is used for:
 * - Tracking player's activity such as whether they are online or offline.
 * - Get the last active time of a player.
 *
 * Typically, player presence is determined from the network activity of the socket server.
 */
class PlayerPresenceSubunit : Subunit<ServerScope> {
    private val onlinePlayers = ConcurrentHashMap<String, PlayerPresence>()

    /**
     * Mark the [playerId] as online.
     *
     * Does nothing if:
     * - the player is already online
     * - `playerId` is equal to [UndeterminedIdentity]
     */
    fun markOnline(playerId: PlayerId) {
        if (playerId == UndeterminedIdentity) {
            Fancam.warn { "markOnline: Undetermined identity won't be marked online" }
            return
        }
        val now = TimeCenter.now()
        onlinePlayers[playerId] = PlayerPresence(
            playerId = playerId,
            onlineSince = now,
            lastNetworkActivity = now,
        )
        Fancam.trace(Tags.Presence) { "PlayerId $playerId is now online" }
    }

    /**
     * Mark the [playerId] as offline. Does nothing if the player is already offline.
     */
    fun markOffline(playerId: PlayerId) {
        onlinePlayers.remove(playerId)
        Fancam.trace(Tags.Presence) { "PlayerId $playerId is now offline" }
    }

    /**
     * Returns whether player with [playerId] is currently online.
     */
    fun isOnline(playerId: PlayerId): Boolean {
        return onlinePlayers.contains(playerId)
    }

    /**
     * Returns whether player with [playerId] is currently online.
     */
    fun isOffline(playerId: PlayerId): Boolean {
        return !onlinePlayers.contains(playerId)
    }

    /**
     * Update the last network activity of [playerId]. Does nothing if the player is not online.
     */
    fun updateLastActivity(playerId: PlayerId) {
        onlinePlayers[playerId]?.lastNetworkActivity = TimeCenter.now()
    }

    override suspend fun debut(scope: ServerScope): Result<Unit> = Result.success(Unit)
    override suspend fun disband(scope: ServerScope): Result<Unit> {
        onlinePlayers.clear()
        return Result.success(Unit)
    }
}
