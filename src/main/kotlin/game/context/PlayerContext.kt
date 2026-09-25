package game.context

import game.mongo.collection.PlayerAccount
import game.mongo.collection.PlayerId
import encore.fancam.Fancam
import encore.network.transport.Connection
import encore.subunit.Subunit
import encore.subunit.scope.PlayerScope
import encore.utils.support.className

/**
 * Represents the **server-side context** of a connected player.
 *
 * This context holds all data and references required to manage a player session:
 * - [playerId] as the player's unique identifier.
 * - The player's [Connection], used to send and receive network messages.
 * - The player's [PlayerAccount], which includes profile and server-related metadata.
 * - The player's game-specific state, accessible through various [PlayerSubunits].
 *
 * During gameplay, [PlayerContext] is frequently accessed.
 * Typically, right after a player successfully authenticates context instance is created.
 * Context creation is handled by [encore.context.ContextFactory] and registered in [encore.context.ContextRegistry].
 */
data class PlayerContext(
    val playerId: PlayerId,
    val connection: Connection,
    val account: PlayerAccount,
    val subunits: PlayerSubunits
)

/**
 * Container for all player-scoped [Subunit] instances.
 *
 * Player subunits encapsulate domain logic that operates at the individual
 * player's level. It typically manages player's data over persistence (database) layer.
 *
 * Player subunits are typically bound to [PlayerScope].
 *
 * Example:
 * - An inventory represents the player's inventory data.
 *   An `InventorySubunit` may expose operations to query or update inventory.
 */
data class PlayerSubunits(
    val example: String = "REPLACE"
) {
    /**
     * Return all player subunit instances.
     * **ADD YOUR NEW SUBUNIT HERE TO BE DEBUTED**
     */
    fun all(): Set<Subunit<PlayerScope>> {
        return setOf()
    }

    /**
     * Debut every player subunit instances with [scope].
     */
    suspend fun debut(scope: PlayerScope) {
        all().forEach { subunit ->
            val result = subunit.debut(scope)
            if (result.isFailure) {
                Fancam.error(result.exceptionOrNull()) { "Result.failure on PlayerSubunit debut '${subunit.className()}'" }
            }
        }
    }

    /**
     * Disband every player subunit instances with [scope].
     */
    suspend fun disband(scope: PlayerScope) {
        all().forEach { subunit ->
            val result = subunit.disband(scope)
            if (result.isFailure) {
                Fancam.error(result.exceptionOrNull()) { "Result.failure on PlayerSubunit disband '${subunit.className()}'" }
            }
        }
    }
}
