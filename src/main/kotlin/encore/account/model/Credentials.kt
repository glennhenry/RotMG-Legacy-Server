package encore.account.model

import game.mongo.collection.PlayerId
import kotlinx.serialization.Serializable

/**
 * Representation of an account credentials in database.
 *
 * @property playerId Unique identifier of the account.
 * @property hashedPassword hashed representation of the account's password.
 */
@Serializable
data class Credentials(
    val playerId: PlayerId,
    val hashedPassword: String
)
