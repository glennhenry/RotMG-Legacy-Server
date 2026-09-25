package encore.annotation.source

/**
 * Marks a piece of code (e.g., a function or class) as undocumented.
 *
 * Highlight code that may contain complicated behavior but
 * is undocumented and require explanation.
 */
@Retention(AnnotationRetention.SOURCE)
annotation class Undocumented(val message: String = "")
