package encore.fancam.events

import encore.fancam.LOG_FILE_EXTENSION
import encore.fancam.TRACK_FILE_EXTENSION
import kotlinx.serialization.Serializable

/**
 * Represent event (a log event) that is routable to a file.
 *
 * @property filename The filemane to be used as the output target.
 */
interface FileRoutableEvent {
    val filename: String?
    val extension: String
}

/**
 * Represent the detailed information of an application logging event.
 *
 * @property message The message of the log call which is evaluated lazily.
 * @property timestamp Timestamp at which this log event was generated.
 * @property level Severity level of the log event.
 * @property tag Short string describing the category for classification of this log event.
 *               To allow multiple tags, separate each with a comma.
 * @property logFull Whether the log message should be printed fully (in case of console output).
 * @property source The source of where the log call was invoked.
 * @property targetFile The filename used when the log event is exported to a file.
 */
data class LogEvent(
    val message: () -> String,
    val timestamp: Long,
    val level: Level,
    val tag: String,
    val logFull: Boolean,
    val source: TraceElement?,
    val throwable: Throwable? = null,
    val targetFile: String?
) : FileRoutableEvent {
    override val filename: String?
        get() = targetFile
    override val extension: String
        get() = LOG_FILE_EXTENSION

    override fun toString(): String {
        return "LogEvent(" +
                "message=<lambdaeval>, " +
                "timestamp=$timestamp, " +
                "level=$level, " +
                "tag=$tag, " +
                "logFull=$logFull, " +
                "source=$source, " +
                "throwable=$throwable, " +
                "targetFile=$targetFile" +
                ")"
    }
}

/**
 * Container for the location of method invocation, usually produced from [StackTraceElement].
 */
@Serializable
data class TraceElement(
    val filename: String?,
    val lineNumber: Int
)

fun StackTraceElement?.toTraceElement(): TraceElement? {
    return this?.let {
        TraceElement(this.fileName, this.lineNumber)
    }
}

/**
 * Represent a detailed information of an application track event,
 * which is a structured logging call.
 *
 * @property name Human-readable identifier for this track event.
 * @property timestamp Timestamp at which this track event was generated.
 * @property data Contains arbitrary key-value pair data in this track event.
 * @property route File at which this track event is exported to, usually default to `events.jsonl`.
 * @property tags List of strings representing categorical information.
 * @property source The source of where the track call was invoked.
 * @property note A free place to write developer note. This shouldn't contain
 *                common information which may belongs to [data], but rather
 *                notes left during odd circumstances.
 */
data class TrackEvent(
    val name: String,
    val timestamp: Long,
    val data: Map<String, Any>,
    val route: String,
    val tags: List<String>,
    val source: TraceElement?,
    val note: () -> String
) : FileRoutableEvent {
    override val filename: String
        get() = route
    override val extension: String
        get() = TRACK_FILE_EXTENSION

    override fun toString(): String {
        return "LogEvent(" +
                "name=$name, " +
                "timestamp=$timestamp, " +
                "route=$route, " +
                "tags=${tags.joinToString(prefix = "[", postfix = "]")}, " +
                "source=$source, " +
                "note=<lambdaeval>, " +
                "data=$data" +
                ")"
    }
}

/**
 * Minimalist representation of [TrackEvent] which is intended for
 * serialized representation on file output target.
 */
data class SimpleTrackEvent(
    val name: String,
    val datetime: String,
    val tags: List<String>,
    val source: TraceElement?,
    val note: String,
    val data: Map<String, Any>
)

/**
 * Convert list of tags into a single string of tags separated by comma.
 */
fun List<String>.tagsToCommaSeparated(): String {
    return this.joinToString(",")
}
