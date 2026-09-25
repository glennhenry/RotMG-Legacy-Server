package game.mongo.collection

import encore.acts.ActScope
import kotlinx.serialization.Serializable

/**
 * Represents server-wide data.
 *
 * This model contains global server data. It may include both
 * gameplay-related data (e.g., leaderboards, clans) and non-game
 * or operational data (e.g., news, analytics).
 *
 * This object is intended to be a singleton within its collection.
 * There should only be one document of `ServerObjects`, keyed specifically
 * with [ServerObjectsId] in the `ServerObjects` collection.
 *
 * @property dbId Unique identifier. Since only one instance of `ServerObjects`
 *                exists, this acts as a fixed key.
 */
@Serializable
data class ServerObjects(
    val dbId: String = ServerObjectsId
)

const val ServerObjectsId = "sobjs"

/**
 * Represent the **one and only** unique identifier for the server.
 *
 * This is used for identification in things like:
 * - [ActScope.ownerId]
 */
const val ServerId = "Xiaoting <33"
