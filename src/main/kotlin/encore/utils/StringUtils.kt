package encore.utils

import encore.fancam.Fancam
import encore.serialization.toJsonElement
import kotlinx.serialization.json.Json
import kotlinx.serialization.json.JsonElement

/**
 * Break the string into multiple lines.
 *
 * For example, `string.breakIntoLines(maxCharsEachLine=5, lineIndent=2)`
 * transforms into:
 * ```
 * abcdefghijklmnopqrstuvwxyz (len=26)
 *
 * abcde
 *   fghij
 *   klmno
 *   pqrst
 *   uvwxy
 *   z
 * ```
 *
 * @param maxCharsEachLine the max chars for each line.
 * @param lineIndent optional amount of spaces to put on each newline.
 */
fun String.breakIntoLines(maxCharsEachLine: Int, lineIndent: Int = 0): String {
    require(maxCharsEachLine > 0)
    val result = StringBuilder(length + length / maxCharsEachLine)

    var start = 0
    while (start < length) {
        val end = minOf(start + maxCharsEachLine, length)
        if (start != 0 && lineIndent != 0) {
            result.append(" ".repeat(lineIndent))
        }
        result.append(this, start, end)
        if (end < length) {
            result.append('\n')
        }
        start = end
    }

    return result.toString()
}

val jsonPrettyPrinter = Json {
    prettyPrint = true
    prettyPrintIndent = "  "
}

/**
 * Converts this into a pretty formatted JSON String.
 *
 * It relies on **reflection** to support any kind of values.
 * It is typically used for structured logging or debugging
 * in combination with the [Fancam] logger.
 */
fun Any.toJsonString(preIndent: Int = 0): String {
    val json = jsonPrettyPrinter.encodeToString(
        JsonElement.serializer(),
        this.toJsonElement(useReflection = true)
    )
    if (preIndent <= 0) return json

    val prefix = "".padStart(preIndent, ' ')

    val lines = json.lines()
    return buildString {
        lines.forEachIndexed { index, string ->
            if (index == 0) {
                append(string)
            } else {
                append(" $prefix$string")
            }
            if (index != lines.lastIndex) {
                append("\n")
            }
        }
    }
}
