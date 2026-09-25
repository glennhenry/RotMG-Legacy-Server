package encore.fancam.events

import encore.fancam.utils.SourceCallResolver
import encore.fancam.Fancam
import encore.time.TimeCenter

/**
 * A DSL-style builder used to construct a [TrackEvent].
 *
 * Example (via [Fancam]):
 * ```kotlin
 * // recorded to default file `events.jsonl`, not logged
 * Fancam.track("SystemHealth")
 *       .data("heat", 12)
 *       .data("playerOnline", 100)
 *       .tags("system", "metric")
 *       .note { if (heat > 10) { "WARNING OVERHEAT" } else "" }
 *       .record()
 *
 * // recorded to `loots.jsonl`, logged with info level
 * Fancam.track("PlayerLoot")
 *       .playerId("pid123")
 *       .username("playerABC")
 *       .data("loot", "bread")
 *       .tags("player", "rng")
 *       .route("loots")
 *       .record()
 *       .log(Level.Info, full = false)
 * ```
 *
 * @property name The name of the track event.
 * @property onRecordCalled Callback when the [record] method is called, providing a [TrackEvent]
 *                          representation at which it was called. The callback is expected to
 *                          properly write the track event to a file specified by the [TrackEvent.route].
 * @property onLogCalled Callback when the [log] method is called, providing a finished [TrackEvent],
 *                       the log level, and log full flag. The callback is expected to
 *                       log the track event to console.
 */
class TrackEventBuilder(
    private val name: String,
    private val onRecordCalled: (TrackEvent) -> Unit,
    private val onLogCalled: (TrackEvent, Level, Boolean) -> Unit,
) {
    private val sourceResolver = SourceCallResolver()

    private val data = mutableMapOf<String, Any>()
    private var tags: List<String> = emptyList()
    private var note: () -> String = { "" }
    private var route: String = "events"

    /**
     * Shorthand to set the `playerId` attribute in the data.
     */
    fun playerId(pid: String) = apply { data["playerId"] = pid }

    /**
     * Shorthand to set the `username` attribute in the data.
     */
    fun username(name: String) = apply { data["username"] = name }

    /**
     * Set the tags for this track event.
     */
    fun tags(vararg tags: String) = apply { this.tags = tags.toList() }

    /**
     * Set the note for this track event.
     */
    fun note(note: () -> String) = apply { this.note = note }

    /**
     * Set the file destination for this track event.
     *
     * Without setting this, the file route is defaulted to `events.jsonl`.
     */
    fun route(route: String) = apply { this.route = route }

    /**
     * Adds a key-value pair in this track event entry.
     *
     * If the [key] already exists in the entry, it will be overwritten.
     */
    fun data(key: String, value: Any) = apply { data[key] = value }

    /**
     * Record the track event to the specified file by [route].
     *
     * Without setting the route, it will be defaulted to `events.jsonl`.
     *
     * This method doesn't finalize the DSL.
     */
    fun record() = apply { onRecordCalled(create()) }

    /**
     * Log this track event while also finalizing the builder.
     *
     * @param level Log level representing this track event severity.
     */
    fun log(level: Level, full: Boolean = false) = onLogCalled(create(), level, full)

    private fun create(): TrackEvent = TrackEvent(
        name = name,
        timestamp = TimeCenter.now(),
        data = data,
        route = route,
        tags = tags,
        source = sourceResolver.resolve(),
        note = note
    )
}
