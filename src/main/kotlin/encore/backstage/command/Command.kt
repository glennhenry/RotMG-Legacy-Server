package encore.backstage.command

import encore.backstage.command.types.ArgumentCollection
import encore.backstage.command.types.CommandResult
import game.context.ServerContext

/**
 * Represents a server command that can be invoked to perform
 * a specific action in the server.
 *
 * Command works by an implementation of this interface.
 * Implement the [execute] method to carry the specific action for the command.
 *
 * Use the command from the command backstage tool.
 * Register your commands in `Application.kt`.
 *
 * See [ExampleCommand] or `encoreTest.backstage.CommandDispatcherTest` for example.
 */
interface Command {
    /**
     * A human-readable name of this command used for invocation.
     *
     * It must be unique to other commands, case-sensitive.
     *
     * For examples: `give`, `give-item`, `give-random-item`
     */
    val commandId: String

    /**
     * An explanation about the command.
     *
     * Use this to explain the command's purpose and the argument details.
     *
     * This will displayed as a help text in the backstage tool.
     *
     * **Note**: It's possible to write HTML markup here.
     */
    val description: String

    /**
     * Contain execution logic of the command.
     *
     * @param serverContext [ServerContext] to be used during execution.
     * @param args Input arguments. This could be empty if the user does not provide any.
     *
     * @return Result of command execution: [CommandResult].
     */
    suspend fun execute(
        serverContext: ServerContext,
        args: ArgumentCollection
    ): CommandResult
}
