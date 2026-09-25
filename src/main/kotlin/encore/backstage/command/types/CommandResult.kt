package encore.backstage.command.types

/**
 * Represents the outcome of executing a server command.
 */
sealed class CommandResult(val message: String = "") {
    /**
     * The command executed successfully.
     */
    class Executed(message: String) : CommandResult(message) {
        override fun toString(): String = "Executed: $message"
    }

    /**
     * Command failed during execution due to a logical or domain error (e.g., player not found, invalid item).
     */
    class ExecutionFailure(message: String) : CommandResult(message) {
        override fun toString(): String = "ExecutionFailure: $message"
    }

    /**
     * The command failed to execute because it was not found (not registered).
     */
    class CommandNotFound(message: String) : CommandResult(message) {
        override fun toString(): String = "CommandNotFound: $message"
    }

    /**
     * The command failed to execute because argument is not enough.
     */
    class NotEnoughArgument(message: String) : CommandResult(message) {
        override fun toString(): String = "NotEnoughArgument: $message"
    }

    /**
     * The command failed to execute because argument type is invalid.
     */
    class InvalidArgumentType(message: String) : CommandResult(message) {
        override fun toString(): String = "InvalidArgumentType: $message"
    }

    /**
     * An unexpected error that is uncaught within the command's execution logic.
     */
    class Error(message: String) : CommandResult(message) {
        override fun toString(): String = "Error: $message"
    }
}
