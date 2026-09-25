package encore.utils.support

/**
 * Consume any type of value and returns a [Unit].
 *
 * This is useful when an expression returns a type, but
 * it is wrapped in a block which expects a Unit type.
 */
fun Any?.asUnit() = Unit
