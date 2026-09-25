package game.mongo.collection

import kotlinx.serialization.Serializable
import encore.account.model.Profile

/**
 * Representation of a player's account.
 *
 * This model is used to represent a player account in the database.
 *
 * @property playerId Unique identifier of the player.
 * @property username Display name of the player.
 * @property email Email address associated with this account.
 * @property hashedPassword Hashed version of the account's password.
 * @property profile Representation of the player's profile.
 */
@Serializable
data class PlayerAccount(
    val playerId: PlayerId,
    val username: String,
    val email: String,
    val hashedPassword: String,
    val profile: Profile,
)

/**
 * Represents a unique player identifier.
 *
 * This alias is used so it's possible to centralize code modification
 * if the underlying type needs to be changed (e.g., to `Long` or `UUID`).
 */
typealias PlayerId = String
