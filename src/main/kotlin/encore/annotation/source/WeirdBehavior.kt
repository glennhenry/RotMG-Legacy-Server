package encore.annotation.source

/**
 * Marks code that exhibits unusual, undocumented, or unclear behavior.
 *
 * This may be intentional, accidental, or the result of reverse-engineering
 * lack of knowledge. This may be revisited later once we know more about it.
 */
@Retention(AnnotationRetention.SOURCE)
annotation class WeirdBehavior(val message: String = "")
