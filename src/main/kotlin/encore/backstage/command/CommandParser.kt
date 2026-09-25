package encore.backstage.command

import encore.backstage.command.types.ArgumentCollection
import encore.backstage.command.types.CommandRequest

/**
 * Parser for command system.
 */
class CommandParser {
    /**
     * Require at least one character that is not a whitespace.
     * Allows only: [[a-z]] [[A-Z]] [[0-9]] [[-]] [[_]] and whitespace
     */
    private val allowedPattern = Regex("^(?=.*\\S)[a-zA-Z0-9_\\-\\s]+$")

    /**
     * Parse the [raw] command input and produce a [CommandRequest].
     *
     * @return [CommandRequest] The processed command request.
     * @throws IllegalArgumentException When input fails to match the [allowedPattern] regex.
     */
    fun parse(raw: String): CommandRequest {
        val trimmed = raw.trim()

        // 1. Empty command
        if (trimmed.isBlank()) {
            throw IllegalArgumentException("Command is blank.")
        }

        // 2. Command does not match regex
        if (!trimmed.matches(allowedPattern)) {
            val badChars = trimmed.filter { !it.isLetterOrDigit() && it !in "_- " }
            throw IllegalArgumentException(
                "Command contains invalid characters: '$badChars'. Allowed: letters, digits, '-', '_', and spaces."
            )
        }

        val tokens = trimmed.split(" ")
        return CommandRequest(
            commandId = tokens.first(),
            arguments = ArgumentCollection(tokens.drop(1))
        )
    }
}
