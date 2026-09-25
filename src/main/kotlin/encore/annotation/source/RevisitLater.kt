package encore.annotation.source

/**
 * Marks a piece of code that is intentionally incomplete
 * or expected to be revisited, redesigned, or replaced later.
 *
 * This annotation highlight technical debt, temporary workarounds, or unfinished logic.
 */
@Retention(AnnotationRetention.SOURCE)
annotation class RevisitLater(val message: String = "")
