package encore.creation

import encore.utils.types.Report
import game.mongo.collection.PlayerAccount
import game.mongo.collection.PlayerId
import game.mongo.collection.PlayerObjects
import game.mongo.collection.PlayerServerObjects
import game.mongo.collection.ServerObjects

/**
 * Component responsible for managing database documents for new player.
 *
 * Implementation defines methods to produce new document to be
 * inserted to each respective collections and update existing
 * server data collection.
 */
interface PlayerCreationFactory {
    /**
     * Generate a new [PlayerId] for the player.
     * @param isAdmin whether the requested ID is intended for admin account.
     */
    fun playerId(isAdmin: Boolean): PlayerId

    /**
     * Produce [PlayerAccount] for the player with the given
     * [playerId], [username], [password], and [email].
     */
    fun account(
        playerId: PlayerId, username: String,
        password: String, email: String
    ): PlayerAccount

    /**
     * Produce [PlayerObjects] for the player.
     */
    fun playerObjects(playerId: PlayerId): PlayerObjects

    /**
     * Produce [PlayerServerObjects] for the player.
     */
    fun playerServerObjects(playerId: PlayerId): PlayerServerObjects

    /**
     * Invoke side effects to the [ServerObjects] collection
     * for the new player.
     *
     * This may contain code like updating leaderboard, friends list, etc.
     *
     * @return [Report.Ok] if every operation succeeded, otherwise [Report.Fail].
     */
    fun updateServerObjects(account: PlayerAccount, objects: PlayerObjects): Report
}
