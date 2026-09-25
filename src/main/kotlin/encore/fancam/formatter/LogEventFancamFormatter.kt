package encore.fancam.formatter

import encore.EncoreFancamConfig
import encore.fancam.events.Level
import encore.fancam.events.LogEvent
import encore.fancam.events.TraceElement
import encore.fancam.events.label
import java.text.SimpleDateFormat
import kotlin.text.padStart
import kotlin.text.take

/**
 * Formatter implementation tailored for:
 * - Log event into console output, which is formatted with ANSI color based on
 *   [EncoreFancamConfig.colorEnabled].
 * - Log event into file output, which is never truncated, not colored, and have
 *   tags always included. This will be set from the flag [isFileTarget].
 */
class LogEventFancamFormatter(
    private val config: EncoreFancamConfig,
    private val isFileTarget: Boolean,
) : FancamFormatter<LogEvent> {
    private val logTimeFormat = SimpleDateFormat("HH:mm:ss.SSS")
    private val fileTimeFormat = SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS")

    override fun format(event: LogEvent): String {
        val timestamp = formatTimestamp(event.timestamp, isFileTarget)
        val source = formatSourceHint(event.source, config.fileNamePadding, isFileTarget)
        val level = if (config.colorEnabled && !isFileTarget) {
            colorizeText(event.level, "[${event.level.label()}]")
        } else {
            "[${event.level.label()}]"
        }

        if (isFileTarget) {
            return buildString {
                // [14:21:54.221](Application.kt:22)[D][InventorySubunit] debug message
                // everything printed, no truncation, no padding
                append("[$timestamp]$source$level[${event.tag.ifBlank { "_" }}] ${event.message()}")
                if (event.level == Level.Error && event.throwable != null) {
                    appendLine()
                    appendLine(event.throwable.toLimitedString(false))
                }
            }
        }

        val message = event.message()
            .lineSequence()
            .joinToString("\n") { line ->
                if (!event.logFull && line.length > config.maxLineLength) {
                    line.take(config.maxLineLength) + " <...truncated>"
                } else {
                    line
                }
            }

        val tag = event.tag
            .take(config.tagPadding)
            .padEnd(config.tagPadding, '_')

        val styledTag = if (config.colorEnabled) {
            if (tag.contains("kp")) {
                colorizeSegmentBg(140, "[$tag]")
            } else {
                if (config.useBackgroundColor) {
                    colorizeSegmentBg(254, "[$tag]")
                } else {
                    colorizeSegmentFg(54, "[$tag]")
                }
            }
        } else {
            "[$tag]"
        }

        return buildString {
            // [14:21:54.221](      Application.kt:22)[D][Server    ] debug message
            // have truncation on tag and message, padding is preserved for source and tag
            append("[$timestamp]$source$level$styledTag $message")
            if (event.level == Level.Error && event.throwable != null) {
                appendLine()
                appendLine(event.throwable.toLimitedString(config.colorEnabled))
            }
        }
    }

    private fun formatTimestamp(timestamp: Long, isFileTarget: Boolean): String {
        return if (isFileTarget) {
            fileTimeFormat.format(timestamp)
        } else {
            logTimeFormat.format(timestamp)
        }
    }

    private fun formatSourceHint(source: TraceElement?, fileNamePadding: Int, noTruncation: Boolean): String {
        if (source == null) return "(UnknownSource)"
        val file = source.filename ?: return "(UnknownFilename)"
        val line = source.lineNumber

        val suffix = ":$line"

        // available space for file name
        val availableSpace = fileNamePadding - suffix.length
        if (availableSpace <= 0) {
            return "(${file.take(1)}...$suffix)"
        }

        val formattedFile = when {
            noTruncation -> file
            file.length <= availableSpace -> file.padStart(availableSpace, ' ')
            else -> middleTruncate(file, availableSpace)
        }

        return "($formattedFile$suffix)"
    }

    private fun middleTruncate(text: String, max: Int): String {
        if (text.length <= max) return text
        if (max <= 3) return ".".repeat(max)

        val keep = max - 3
        val left = keep / 2
        val right = keep - left

        return text.take(left) + "..." + text.takeLast(right)
    }

    private fun colorizeText(level: Level, text: String): String {
        val fg: String
        val bg: String

        if (config.useBackgroundColor) {
            fg = AnsiColors.BlackText
            bg = when (level) {
                Level.Trace -> AnsiColors.TraceBg
                Level.Debug -> AnsiColors.DebugBg
                Level.Info -> AnsiColors.InfoBg
                Level.Warn -> AnsiColors.WarnBg
                Level.Error -> AnsiColors.ErrorBg
                Level.Off -> AnsiColors.bg(140)
            }
        } else {
            bg = ""
            fg = when (level) {
                Level.Trace -> AnsiColors.TraceFg
                Level.Debug -> AnsiColors.DebugFg
                Level.Info -> AnsiColors.InfoFg
                Level.Warn -> AnsiColors.WarnFg
                Level.Error -> AnsiColors.ErrorFg
                Level.Off -> AnsiColors.fg(140)
            }
        }

        return "$bg$fg$text${AnsiColors.Reset}"
    }
}

/**
 * Format a throwable into a string with limits of [maxFrames] and [maxCauses].
 */
fun Throwable.toLimitedString(
    colorEnabled: Boolean,
    maxFrames: Int = 8,
    maxCauses: Int = 3
): String {
    fun redColor(text: String): String {
        return if (colorEnabled) {
            "${AnsiColors.fg(160)}$text${AnsiColors.Reset}"
        } else {
            text
        }
    }

    fun Throwable.format(depth: Int): String {
        if (depth >= maxCauses) {
            return "        ... (cause chain truncated)\n"
        }

        val header = buildString {
            if (depth == 0) append(redColor("  (!) "))
            append(redColor("${this@format::class.simpleName}: $message"))
        }

        val frames = stackTrace
            .take(maxFrames)
            .joinToString("\n") { "        at $it" }

        val more = stackTrace.size - maxFrames
        val moreLine = when {
            more <= 0 -> ""
            cause == null -> "        ... $more more"
            else -> "        ... $more more\n"
        }

        val causePart = cause?.let {
            redColor("    Caused by: ") + it.format(depth + 1)
        } ?: ""

        return buildString {
            appendLine(header)
            appendLine(frames)
            append(moreLine)
            append(causePart)
        }
    }

    return this.format(0)
}
