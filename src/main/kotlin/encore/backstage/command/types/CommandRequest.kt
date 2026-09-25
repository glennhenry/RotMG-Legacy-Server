package encore.backstage.command.types

/**
 * Represent a single command request from user with the
 * specific [commandId] and input of [arguments].
 */
data class CommandRequest(
    val commandId: String,
    val arguments: ArgumentCollection
)
