package encore.acts

/**
 * Runtime lookup store for active [StageAct] identifiers.
 *
 * This component allows externally locating a running act through
 * application-defined string identities, typically derived from one or more
 * fields of the corresponding [ActConcept].
 *
 * Common examples include:
 * - `"playerId-buildingId"`
 * - `"playerId-upgradeType"`
 *
 * Usage:
 * - [bind] and [unbind] to associate an identity with an `actId`.
 * - [find] to get the `actId` from identity.
 *
 * Note:
 * - `bind` should be manually invoked by the caller that initiates the act.
 *   The director does not have the responsibility to bind any running tasks,
 *   because not every acts aims to be cancellable manually.
 * - `unbind` will be called automatically by the director.
 */
object ActIdStore {
    private val identities = mutableMapOf<String, String>()
    private val actIds = mutableMapOf<String, String>()

    /**
     * Associates an [identity] with an active [actId].
     *
     * This allows the act to later be located through [find].
     *
     * @param actId Unique identifier of the running [StageAct].
     * @param identity Application-defined runtime identity.
     */
    fun bind(actId: String, identity: String) {
        actIds[actId] = identity
        identities[identity] = actId
    }

    /**
     * Removes the identity association of the specified [actId].
     *
     * This should typically be called when the corresponding act
     * completes, fails, or is cancelled.
     */
    fun unbind(actId: String) {
        val identity = actIds.remove(actId)
            ?: return

        identities.remove(identity)
    }

    /**
     * Finds the associated `actId` for the specified [identity].
     *
     * @param identity Application-defined runtime identity.
     * @return The associated `actId`, or `null` if no active act is bound.
     */
    fun find(identity: String): String? {
        return identities[identity]
    }

    /**
     * Clear all associated identities or act identifiers.
     */
    fun clear() {
        identities.clear()
        actIds.clear()
    }
}
