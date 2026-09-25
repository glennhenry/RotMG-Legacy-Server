package encore.datastore

import bootstrap.CodecRegistry
import com.mongodb.client.result.DeleteResult
import com.mongodb.client.result.UpdateResult
import org.bson.Document
import org.bson.conversions.Bson

/**
 * Thrown when a MongoDB query expected a document but found none.
 */
class DocumentNotFoundException(message: String) : RuntimeException(message)

/**
 * Thrown when a MongoDB update operation does not update
 * the specified document (i.e., when `modifiedCount < 1`).
 */
class DocumentNotUpdatedException(message: String) : RuntimeException(message)

/**
 * Thrown when a MongoDB delete operation does not delete
 * any document (i.e., when `deletedCount < 1`).
 */
class DocumentNotDeletedException(message: String) : RuntimeException(message)

/**
 * Thrown when a MongoDB write operation (e.g., insert, update, delete)
 * is not acknowledged.
 */
class MongoNotAcknowledged(message: String) : RuntimeException(message)

/**
 * Executes [block] and wraps its result in a [Result].
 *
 * This is typically used for queries such as find one that may return `null`
 * (e.g. by calling `firstOrNull`).
 *
 * Behavior:
 * - Returns [Result.success] if [block] returns a non-null value.
 * - Returns [Result.failure] with [DocumentNotFoundException] if the result is null.
 * - Returns [Result.failure] if [block] throws.
 *
 * @param message message used when the result is null
 */
inline fun <T> runMongoCatching(
    message: String = "Expected document to exist",
    block: () -> T?
): Result<T> = runCatching {
    block() ?: throw DocumentNotFoundException(message)
}

/**
 * Throw an error if the update operation does not match any document.
 *
 * @param context Information about the update operation and will be included in the exception.
 * @param filter Optional lambda containing the Mongo `Filters` which will be included in the exception.
 * @throws MongoNotAcknowledged if the operation is not acknowledged.
 * @throws DocumentNotFoundException if `matchedCount` is less than 1
 */
fun UpdateResult.throwIfNothingMatched(
    context: String = "",
    filter: (() -> Bson?)? = null,
) {
    if (!wasAcknowledged()) throw MongoNotAcknowledged("MongoDB update not acknowledged: $context")

    if (matchedCount < 1) {
        val filterStr = filter?.invoke()?.toBsonDocument(Document::class.java, CodecRegistry)?.toJson()
        throw DocumentNotFoundException(
            "No document matched: $context\n" +
                    (filterStr?.let { "     filter=$it" } ?: "")
        )
    }
}

/**
 * Throw an error if the update operation does not match any document or modify any.
 *
 * **Note**: A document will not be considered as modified if the document
 * is already in the state requested by the operation. For example,
 * a document having value `x = 1` with a request updating `x` to 1;
 * the document will not be updated and **this function will throw**.
 *
 * Use this only if an update operation must always change a document state.
 * Otherwise, [throwIfNothingMatched] may be suitable alternative.
 *
 * @param context Information about the update operation and will be included in the exception.
 * @param filter Optional lambda containing the Mongo `Filters` which will be included in the exception.
 * @param update Optional lambda containing the Mongo `Update` which will be included in the exception.
 * @throws DocumentNotFoundException if `matchedCount` is less than 1
 * @throws DocumentNotUpdatedException if `modifiedCount` is less than 1
 */
fun UpdateResult.throwIfNothingModified(
    context: String = "",
    filter: (() -> Bson?)? = null,
    update: (() -> Bson?)? = null,
) {
    if (!wasAcknowledged()) throw MongoNotAcknowledged("MongoDB update not acknowledged: $context")

    if (matchedCount < 1) {
        val filterStr = filter?.invoke()?.toBsonDocument(Document::class.java, CodecRegistry)?.toJson()
        throw DocumentNotFoundException(
            "No document matched: $context\n" +
                    (filterStr?.let { "     filter=$it" } ?: "")
        )
    }

    if (modifiedCount < 1) {
        val filterStr = filter?.invoke()?.toBsonDocument(Document::class.java, CodecRegistry)?.toJson()
        val updateStr = update?.invoke()?.toBsonDocument(Document::class.java, CodecRegistry)?.toJson()
        throw DocumentNotUpdatedException(
            "Document matched but not modified: $context\n" +
                    (filterStr?.let { "     filter=$it" } ?: "") +
                    (updateStr?.let { "\n     update=$it" } ?: "")
        )
    }
}

/**
 * Throw an error if the delete operation does not delete anything.
 * Use this only if a delete operation is expected to delete something.
 *
 * @param context Information about the update operation and will be included in the exception.
 * @param filter Optional lambda containing the Mongo `Filters` which will be included in the exception.
 * @throws DocumentNotDeletedException if `deletedCount` is less than 1
 */
fun DeleteResult.throwIfNothingDeleted(
    context: String = "",
    filter: (() -> Bson?)? = null,
) {
    if (!wasAcknowledged()) throw MongoNotAcknowledged("MongoDB delete not acknowledged: $context")

    if (deletedCount < 1) {
        val filterStr = filter?.invoke()?.toBsonDocument(Document::class.java, CodecRegistry)?.toJson()
        throw DocumentNotDeletedException(
            "No document deleted: $context\n" +
                    (filterStr?.let { "     filter=$it" } ?: "")
        )
    }
}
