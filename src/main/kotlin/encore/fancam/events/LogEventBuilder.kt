package encore.fancam.events

import encore.fancam.Fancam
import encore.fancam.impl.OfficialFancam
import encore.time.TimeCenter

/**
 * A DSL-style builder used to construct [LogEvent].
 *
 * Example (via [Fancam]):
 * ```kotlin
 * // log to console
 * Fancam.event(Level.Info, "InventorySubunit")
 *       .message { "subunit working..." }
 *       .log(full = true)
 *
 * // log to console + file
 * Fancam.event(Level.Info, "InventorySubunit")
 *       .message { "subunit working..." }
 *       .setFileTarget("Subunit")
 *       .log(full = true)
 *
 * // log to file
 * Fancam.event(Level.Info, "InventorySubunit")
 *       .message { "subunit working..." }
 *       .logToFile("Subunit")
 * ```
 *
 * @param onLogCalled Callback used when this builder is finalized, providing
 *                    the constructed [LogEvent] and boolean value specifying
 *                    whether the log is `fileOnlyOutput`.
 */
class LogEventBuilder(
    private val level: Level,
    private val tag: String,
    private val src: TraceElement?,
    private val onLogCalled: (LogEvent, Boolean) -> Unit
) {
    private var message: () -> String = { "Nothing was logged" }
    private var target: String? = null
    private var throwable: Throwable? = null

    /**
     * Set the lazily evaluated message for the log event.
     *
     * Subsequent call will overwrite the previous.
     */
    fun message(message: () -> String): LogEventBuilder = apply {
        this.message = message
    }

    /**
     * Set the file target of this log event.
     *
     * Only one file target is possible, subsequent call will overwrite it.
     *
     * Setting the file target won't be necessary if [logToFileOnly] is called at the end.
     *
     * @param filename The filename without extension.
     */
    fun setFileTarget(filename: String): LogEventBuilder = apply {
        this.target = filename
    }

    /**
     * Set the throwable for this event.
     *
     * This call will be ignored if the log event's [level]
     * is not [Level.Error].
     *
     * @param throwable a non-null throwable.
     */
    fun setThrowable(throwable: Throwable): LogEventBuilder = apply {
        if (level != Level.Error) {
            return this
        }
        this.throwable = throwable
    }

    /**
     * Finalize the builder and log the event.
     *
     * This will also output the log event into a file if [setFileTarget]
     * was called before. If you want file only output, use [logToFileOnly].
     *
     * @param full To specify whether the log event should be printed fully.
     *             This is ignored on [OfficialFancam] implementation for file target.
     */
    fun log(full: Boolean = false) {
        onLogCalled(
            LogEvent(
                message = message,
                timestamp = TimeCenter.now(),
                level = level,
                tag = tag,
                logFull = full,
                source = src,
                throwable = throwable,
                targetFile = target,
            ), false
        )
    }

    /**
     * Finalize the builder and log the event to the specified filename by [setFileTarget].
     *
     * By using this method, log won't be outputted to console.
     *
     * Note: the file target is as specified by [filename] and not by [setFileTarget].
     *
     * @param filename The filename without extension.
     */
    fun logToFileOnly(filename: String) {
        onLogCalled(
            LogEvent(
                message = message,
                timestamp = TimeCenter.now(),
                level = level,
                tag = tag,
                logFull = true,
                source = src,
                throwable = throwable,
                targetFile = filename,
            ), true
        )
    }
}
