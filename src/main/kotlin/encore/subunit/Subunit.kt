package encore.subunit

import encore.subunit.scope.SubunitScope
import encore.subunit.scope.ServerScope
import encore.utils.types.Outcome
import encore.utils.types.Report

/**
 * A `Subunit` is a scope-bound service responsible for managing
 * domain data and behavior within a specific [SubunitScope].
 *
 * ### Overview
 *
 * It acts as a domain-level abstraction that may:
 * - Encapsulate business logic for a specific domain.
 * - Coordinate persistence through repositories when needed.
 * - Maintain an in-memory representation of scoped data
 *   to reduce repeated database access.
 *
 * A `Subunit` may also function as a "stateless subsystem",
 * providing domain-specific functionality without necessarily
 * managing data or persistence.
 *
 * For example, a Subunit bound to [ServerScope] operates at the
 * server level, supporting a particular server concern.
 *
 * Subunits typically are not aware of each other and are orchestrated
 * externally (e.g., by handlers or controllers).
 *
 * Lifecycle:
 * - [debut] initializes the subunit. This should be called before usage.
 * - [disband] closes the subunit. This should be called after usage is finished.
 *
 * ### Implementation
 *
 * - Subunit should remain focused on a single domain concern.
 * - Subunit should not perform low-level database operations directly
 *   and instead provide abstraction to caller. DB operations should be
 *   directed to repository classes.
 * - When operating with a repository, subunit should handles the [Result]
 *   type returned by each repository operations.
 * - In a strict handling requirement, subunit may:
 *     - Use the [Report] type for operations that returns `Unit`.
 *     - Use the [Outcome] type for operations that returns a value.
 *
 * See example in `test.example.SubunitRepository`.
 */
interface Subunit<T : SubunitScope> {
    /**
     * Debut the subunit for the given [scope].
     *
     * This method should be used to prepare or load the required state.
     * Must call this before any usage.
     *
     * @return A result type to denote success or failure.
     */
    suspend fun debut(scope: T): Result<Unit>

    /**
     * Disband the subunit for the given [scope].
     *
     * This method is called when the subunit closes (e.g., server shutdown,
     * player logs off or disconnects).
     * Must call this after usage is finished.
     *
     * It should do the necessary clean-up or persist any in-memory state
     * to storage to ensure no progress or transient data is lost.
     *
     * @return A result type to denote success or failure.
     */
    suspend fun disband(scope: T): Result<Unit>
}
