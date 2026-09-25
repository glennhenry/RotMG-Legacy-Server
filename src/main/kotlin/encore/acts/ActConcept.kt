package encore.acts

import encore.acts.choreo.BasicChoreography
import game.mongo.collection.PlayerId
import encore.network.transport.Connection

/**
 * Marker interface representing the input for a stage act.
 *
 * An `ActConcept` encapsulates all data required to execute a [StageAct].
 * This includes both static and runtime data, but excludes external dependencies.
 *
 * For instance, a building construction task for a player may include:
 * - [PlayerId] of the player
 * - `buildingId` identifiying the building being constructed.
 * - `finishAt` defining when the construction would finish, which is also used
 *   to determine the act's delay in [BasicChoreography].
 * - [Connection] object used to send a building constructed message.
 *
 * External dependencies (e.g., `BuildingSubunit`) should not be part of the concept
 * and must instead be injected into the [StageAct] implementation.
 *
 * All stage act input types should implement this interface.
 */
interface ActConcept
