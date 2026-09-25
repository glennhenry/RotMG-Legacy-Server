package encore.network.transport

import game.mongo.collection.PlayerId

/**
 * Represent the identity information of a [Connection] object.
 *
 * @property playerId The in-game identifier of the connected player.
 * @property username The display name associated with the player.
 * @property remoteAddress The logical remote location of this connection (e.g., IP address).
 */
data class ConnectionIdentity(
    var playerId: PlayerId? = null,
    var username: String? = null,
    val remoteAddress: String,
) {
    /**
     * String representation returns the [username] with 8 characters prefix
     * of the [playerId].
     *
     * Example:
     * ```txt
     * playerId = f51ac90b-12cc-4372-a567-0e02b2c3d479
     * username = playerABC
     *
     * [username=playerABC/playerId=f51ac90b]
     * ```
     *
     * If `playerId` or `username` is unset, [remoteAddress] will be returned instead.
     */
    override fun toString(): String {
        return if (username == null && playerId == null) {
            "[addr=$remoteAddress]"
        } else {
            "[username=$username/playerId=${playerId?.take(8)}]"
        }
    }
}

const val UndeterminedIdentity = "[Undetermined]"
