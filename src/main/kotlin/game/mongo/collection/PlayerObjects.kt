package game.mongo.collection

import game.Globals

/**
 * Root representation of all persistent game data for a player.
 *
 * This model is intended to hold core game data only. Server-managed or
 * administrative metadata (e.g., bans, flags, temporary states) should be
 * stored separately in [PlayerServerObjects].
 *
 * @property playerId Unique identifier of the player.
 */
data class PlayerObjects(
    val playerId: PlayerId,
) {
    /**
     * Template to create player objects.
     *
     * Creation method is written here and updated accordingly
     * to avoid frequent modification in the framework code.
     */
    companion object {
        fun admin(): PlayerObjects {
            return PlayerObjects(
                playerId = Globals.ADMIN_PLAYER_ID,
            )
        }

        fun newGame(playerId: PlayerId): PlayerObjects {
            return PlayerObjects(
                playerId = playerId,
            )
        }
    }
}
