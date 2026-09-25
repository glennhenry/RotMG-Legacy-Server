package encore.backstage.command

import encore.backstage.command.types.CommandRequest
import encore.backstage.command.types.CommandResult
import encore.fancam.Fancam
import encore.fancam.Tags
import game.context.ServerContext

/**
 * Dispatch and execute server registered commands.
 *
 * Server commands offers the ability to control the server from command implementation.
 * It gives the possibility to modify server's behavior, such as modifying user's data.
 *
 * The server accepts command from a simple text input in the external web devtools (backstage).
 *
 * How to use:
 * - Implement [Command].
 * - Register the command with [register].
 * - Via the backstage, type the command with input arguments.
 * - Syntax typically looks like 'give userABC water 100'.
 *
 * See example in `test.backstage.CommandDispatcherTest`.
 */
class CommandDispatcher {
    private val commands = mutableMapOf<String, Command>()
    private val parser = CommandParser()

    /**
     * Require at least one character that is not a whitespace.
     * Allows only: [[a-z]] [[A-Z]] [[0-9]] [[-]] [[_]] and whitespace
     */
    private val allowedPattern = Regex("^(?=.*\\S)[a-zA-Z0-9_\\-\\s]+$")

    /**
     * Register a server command.
     *
     * @param command The command implementation to be registered.
     * @throws IllegalArgumentException throws when:
     * - `commandId` is blank or contains invalid character (see [allowedPattern]).
     */
    fun register(command: Command) {
        val cleanId = sanitizeCommandId(command.commandId)

        if (cleanId in commands) {
            Fancam.warn(Tags.Command) { "The commandId '${cleanId}' has been registered before, the old one will be overwritten." }
        }

        commands[cleanId] = command
    }

    private fun sanitizeCommandId(id: String): String {
        // 1. Empty commandId
        if (id.isBlank()) {
            throw IllegalArgumentException("commandId is blank.")
        }

        // 2. Command does not match regex
        if (!id.matches(allowedPattern)) {
            val badChars = id.filter { !it.isLetterOrDigit() && it !in "_- " }
            throw IllegalArgumentException(
                "commandId contains invalid characters: '$badChars'. Allowed: letters, digits, '-', '_', and spaces."
            )
        }

        return id.trim()
    }

    /**
     * Handle raw command request in plain string.
     *
     * @return [CommandResult] that represents the outcome.
     */
    suspend fun handleRawCommand(raw: String, serverContext: ServerContext): CommandResult {
        val request = try {
            parser.parse(raw)
        } catch (e: IllegalArgumentException) {
            // parse error from parser which is not severe
            return CommandResult.Error("Parsing scandal: ${e.message}")
        } catch (e: Exception) {
            Fancam.error(e, Tags.Command) { "Unexpected parsing scandal on '$raw'" }
            return CommandResult.Error("Parsing scandal: ${e.message}")
        }

        return handleCommand(request, serverContext)
    }

    /**
     * Handle command request.
     *
     * It involves doing a lookup to the registered commands, then
     * calling `execute` method in the command implementation.
     *
     * @return [CommandResult] that represents the outcome.
     */
    suspend fun handleCommand(request: CommandRequest, serverContext: ServerContext): CommandResult {
        val command = commands[request.commandId] ?: return CommandResult.CommandNotFound(request.commandId)

        Fancam.info(Tags.Command) { "Received command '${request.commandId} ${request.arguments}'" }

        try {
            val result = command.execute(serverContext, request.arguments)
            Fancam.info(Tags.Command) { "Executed command '${request.commandId}' with result ($result)" }
            return result
        } catch (e: Exception) {
            Fancam.error(e, Tags.Command) { "Scandal while executing the command '${request.commandId}'" }
            return CommandResult.Error("Execution scandal: ${e.message}")
        }
    }

    /**
     * @return [Set] of registered `commandId`(s).
     */
    fun getAllRegisteredCommandsId(): Set<String> {
        return commands.keys
    }

    /**
     * @return [Set] of registered commands.
     */
    fun getAllRegisteredCommands(): Set<Command> {
        return commands.values.toSet()
    }
}
