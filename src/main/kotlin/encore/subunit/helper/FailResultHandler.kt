package encore.subunit.helper

import encore.datastore.DocumentNotFoundException
import encore.datastore.DocumentNotUpdatedException
import encore.fancam.Fancam
import encore.fancam.Tags

/**
 * Handles a [Throwable] in the context of a subunit's **get/retrieval operations**.
 *
 * Subunits often call repository functions that return [Result] types. When a
 * repository operation fails, it wraps exceptions (e.g., [DocumentNotFoundException])
 * in the `Result`. Subunits then need to handle these exceptions, which can lead
 * to repetitive boilerplate.
 *
 * This helper provides a concise way to:
 *   1. Log domain-specific messages for known exceptions (like `DocumentNotFoundException`).
 *   2. Log a default or custom message for unknown exceptions.
 *
 * Usage:
 * ```
 * result.onFailure {
 *     it.handleGet(
 *         notFoundMessage = { "Items not found for player $playerId" },
 *         unknownMessage  = { "Failed to fetch items for player $playerId" }
 *     )
 * }
 * ```
 *
 * @param notFoundMessage Message to log when a [DocumentNotFoundException] is thrown
 * @param unknownMessage Message to log when any other unknown exception is thrown
 */
inline fun Throwable.failHandleGet(
    crossinline notFoundMessage: () -> String = { "Get operation failed: document not found" },
    crossinline unknownMessage: () -> String = { "Get operation failed with an unknown error" }
) {
    when (this) {
        is DocumentNotFoundException -> Fancam.error(this) { notFoundMessage() }
        else -> Fancam.error(this, Tags.Subunit) { unknownMessage() }
    }
}

/**
 * Handles a [Throwable] in the context of a subunit's **update operations**.
 *
 * Similar to [failHandleGet], but designed for update operations which adds
 * additional matching for [DocumentNotUpdatedException].
 *
 * Usage:
 * ```
 * result.onFailure {
 *     it.handleGet(
 *         notFoundMessage = { "Items not found for player $playerId" },
 *         notUpdatedMessage = { "Failed to update role for player $playerId" },
 *         unknownMessage  = { "Failed to fetch items for player $playerId" }
 *     )
 * }
 * ```
 *
 * @param notFoundMessage Message to log when a [DocumentNotFoundException] is thrown
 * @param notUpdatedMessage Message to log when a [DocumentNotUpdatedException] is thrown
 * @param unknownMessage Message to log when any other unknown exception is thrown
 */
inline fun Throwable.failHandleUpdate(
    crossinline notFoundMessage: () -> String = { "Update failed: document not found" },
    crossinline notUpdatedMessage: () -> String = { "Update failed: no document affected" },
    crossinline unknownMessage: () -> String = { "Update failed with unknown error" }
) {
    when (this) {
        is DocumentNotFoundException -> Fancam.error(this) { notFoundMessage() }
        is DocumentNotUpdatedException -> Fancam.error(this) { notUpdatedMessage() }
        else -> Fancam.error(this, Tags.Subunit) { unknownMessage() }
    }
}
