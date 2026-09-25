package encore.backstage.command.types

/**
 * A wrapper around the list of raw argument strings provided to a command.
 *
 * Arguments are consumed in order. Convenience methods are provided to
 * retrieve and convert values:
 * - [next] for raw strings.
 * - [nextInt], [nextBoolean], [nextDouble] for typed values.
 * - [nextIntOr], [nextBooleanOr], [nextDoubleOr] to support defaults.
 *
 * Arguments that cannot be converted to the requested type will return `null`.
 */
class ArgumentCollection(private val arguments: List<String>) {
    private var index = 0

    /**
     * Get the next argument as `String`.
     *
     * May return `null` when there is no more argument next.
     */
    fun next(): String? = arguments.getOrNull(index).also { index++ }

    /**
     * Get the next argument as `Int`.
     *
     * May return `null` when there is no more argument next or type conversion failed.
     */
    fun nextInt(): Int? = next()?.toIntOrNull()

    /**
     * Get the next argument as `Int` or a [default].
     */
    fun nextIntOr(default: Int): Int = nextInt() ?: default

    /**
     * Get the next argument as `Boolean`.
     *
     * May return `null` when there is no more argument next or type conversion failed.
     */
    fun nextBoolean(): Boolean? = next()?.toBooleanStrictOrNull()

    /**
     * Get the next argument as `Boolean` or a [default].
     */
    fun nextBooleanOr(default: Boolean): Boolean = nextBoolean() ?: default

    /**
     * Get the next argument as `Double`.
     *
     * May return `null` when there is no more argument next or type conversion failed.
     */
    fun nextDouble(): Double? = next()?.toDoubleOrNull()

    /**
     * Get the next argument as `Double` or a [default] when there is no more
     * argument next or type conversion failed.
     */
    fun nextDoubleOr(default: Double): Double = nextDouble() ?: default

    override fun equals(other: Any?): Boolean {
        return other is ArgumentCollection && this.arguments.zip(other.arguments).all { (a, b) -> a == b }
    }

    override fun hashCode(): Int {
        return 31 * index + arguments.hashCode()
    }

    override fun toString(): String {
        return arguments.joinToString(" ")
    }
}
