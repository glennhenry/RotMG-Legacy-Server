package encore.subunit.scope

import encore.subunit.Subunit

/**
 * Represents the execution context of a [Subunit].
 *
 * A scope defines the boundary in which a subunit operates,
 * including what data it can access and how it should behave.
 *
 * Examples:
 * - A subunit with [PlayerScope] operates within the context of a single player.
 *   The provided [PlayerScope.playerId] can be used to load and persist
 *   player-specific data via a repository.
 * - A subunit with [ServerScope] operates at the server level.
 *   It may manage global state (e.g., leaderboards) or provide
 *   stateless functionality (e.g., matchmaking).
 */
interface SubunitScope
