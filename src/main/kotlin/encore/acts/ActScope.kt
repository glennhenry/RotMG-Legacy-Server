package encore.acts

import game.mongo.collection.PlayerId
import game.mongo.collection.ServerId
import kotlinx.coroutines.CoroutineScope

/**
 * Represent the scope to which a [StageAct] is bound to.
 *
 * A stage act is bound to an owner that determines its lifetime.
 * The owner can be a particular player or the server itself.
 *
 * For example, if an act is bound to a player and their connection is dead,
 * the act will seen as invalid, and thus cancelled. This is determined
 * through the owner's [coroutineScope].
 */
data class ActScope(
    /**
     * The globally unique identifier of the [StageAct] owner.
     *
     * This is used for debugging and diagnostic purpose.
     *
     * For player this should be [PlayerId].
     * Server-owned acts should use the [ServerId].
     */
    val ownerId: String,

    /**
     * The coroutine scope which the act will run on.
     */
    val coroutineScope: CoroutineScope
)
