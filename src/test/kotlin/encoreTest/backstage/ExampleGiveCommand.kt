package encoreTest.backstage

import encore.backstage.command.Command
import encore.backstage.command.types.ArgumentCollection
import encore.backstage.command.types.CommandResult
import game.context.ServerContext

/**
 * Example of how command can be implemented.
 *
 * In this case, a 'give' command where the server gives a
 * specific item to a particular user for an amount.
 */
class ExampleGiveCommand : Command {
    override val commandId: String = "give"
    override val description: String = """
    Give a particular item of an amount to a specific user.
    
    There are 3 arguments:
    - userId: String (required) = the target userId.
    - itemId: String (required) = the ID of item to be given.
    - amount: Int (optional) = amount of item to be sent, default=1.
    
    """.trimIndent()

    /**
     * amount = 2 simulates uncaught exception, amount = 3 simulates failure
     */
    override suspend fun execute(serverContext: ServerContext, args: ArgumentCollection): CommandResult {
        val userId = args.next() ?: return CommandResult.NotEnoughArgument("userId is required")
        val itemId = args.next() ?: return CommandResult.NotEnoughArgument("itemId is required")

        val expectedAmount = args.next()
        val amount = if (expectedAmount != null) {
            expectedAmount.toIntOrNull()
                ?: return CommandResult.InvalidArgumentType("amount is supposed to be an Integer type, got: $expectedAmount")
        } else {
            1
        }

        if (amount == 2) throw Exception()
        if (amount == 3) return CommandResult.ExecutionFailure("Failed to execute")

        return CommandResult.Executed("Successfully give $amount $itemId to $userId.")
    }
}
