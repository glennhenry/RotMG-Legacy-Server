package game.mongo.collection

import game.Globals

/**
 * Represents server-managed player data.
 *
 * This model contains player-owned, non-gameplay related data that is
 * managed by the server. It may include administrative metadata
 * (e.g., bans, flags, temporary states) or per-player tracking data
 * that is needed by the server but isn't classified as game data.
 *
 * @property playerId Unique identifier of the player.
 * @property extra Miscellaneous information of the player.
 */
data class PlayerServerObjects(
    val playerId: PlayerId,
    val extra: Map<String, String> = emptyMap(),
) {
    /**
     * Template to create player server objects.
     *
     * Creation method is written here and updated accordingly
     * to avoid frequent modification in the framework code.
     */
    companion object {
        fun admin(): PlayerServerObjects {
            return PlayerServerObjects(
                playerId = Globals.ADMIN_PLAYER_ID
            )
        }

        fun newGame(playerId: PlayerId): PlayerServerObjects {
            return PlayerServerObjects(
                playerId = playerId
            )
        }
    }
}
