package encore.backstage.command.types

/**
 * Describes a single command argument.
 *
 * This metadata is used for help text generation. It does not perform or enforce type safety.
 *
 * @property id A human-readable identifier for the argument (used for display).
 * @property expectedType The expected value type (e.g., "String", "Int", "Boolean", "Double").
 *                        Informational only.
 * @property description An explanation of what the argument represents or controls.
 */
data class ArgumentDescriptor(
    val id: String,
    val expectedType: String,
    val description: String,
) {
    override fun toString(): String {
        return "$id: $expectedType = $description"
    }
}
