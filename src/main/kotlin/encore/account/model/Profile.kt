package encore.account.model

import game.mongo.collection.PlayerId
import kotlinx.serialization.Serializable

/**
 * Player profile information.
 *
 * `Profile` contains the player's personal information in the server
 * such as country, avatar, locale, etc. It does not include game-specific
 * information like player's ranking or status.
 *
 * @property playerId Unique identifier of the player.
 * @property createdAt Epoch millis of the account creation date.
 * @property lastActiveAt Epoch millis of the account last activity.
 */
@Serializable
data class Profile(
    val playerId: PlayerId,
    val createdAt: Long,
    val lastActiveAt: Long,
)
