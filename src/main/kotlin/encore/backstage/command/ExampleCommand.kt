package encore.backstage.command

import encore.backstage.command.types.ArgumentCollection
import encore.backstage.command.types.CommandResult
import game.context.ServerContext

/**
 * An example implementation of command.
 * Does nothing meaningful beside introducing patterns and testing command invocation.
 */
class ExampleCommand : Command {
    override val commandId: String = "test"
    override val description: String = """
    This is merely a <strong>test command</strong>, does nothing actually.
    
    Use this argument by invoking it like 'give a b c'.

    There are 3 arguments in total, the last arg 'c' is optional.
    - a: String = an example of required string argument.
    - b: String = an example of required string argument.
    - c: String (default = 1) = an example of the number type.
    
    Use c = 2 to simulate uncaught exception.
    Use c = 3 to simulate a domain failure.      
""".trimIndent()

    override suspend fun execute(serverContext: ServerContext, args: ArgumentCollection): CommandResult {
        val a = args.next() ?: return CommandResult.NotEnoughArgument("first argument 'a' is required")
        val b = args.next() ?: return CommandResult.NotEnoughArgument("second argument 'b' is required")

        val expectedC = args.next()
        val c = if (expectedC != null) {
            expectedC.toIntOrNull()
                ?: return CommandResult.InvalidArgumentType("third argument 'c' is supposed to be a Number type, got: '$expectedC'")
        } else {
            1
        }

        if (c == 2) throw Exception("Used c=2, here's an uncaught exception.")
        if (c == 3) return CommandResult.ExecutionFailure("Used c=3, here's a domain error.")

        return CommandResult.Executed("Success 'test' command with args: a=$a, b=$b, c=$c")
    }
}
