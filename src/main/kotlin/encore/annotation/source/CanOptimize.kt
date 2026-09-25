package encore.annotation.source

/**
 * Marks a piece of code as optimizable, highlighting a potential
 * improvement to make the code cleaner, efficient, faster, etc.
 */
@Retention(AnnotationRetention.SOURCE)
annotation class CanOptimize(val message: String = "")
