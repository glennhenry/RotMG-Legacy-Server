package encore.utils.support

import encore.fancam.Fancam

/**
 * Safely execute the given [block] within a try-catch guard.
 * This will log any caught [Throwable] via [Fancam] and
 * returns `null` if an error occurs.
 *
 * @param block The block of code to run.
 * @param R The return type of block.
 * @return The result of [block] or `null` if an exception was thrown.
 */
fun <R> safely(block: () -> R): R? {
    return try {
        block()
    } catch (t: Throwable) {
        Fancam.error(t) { "Scandal detected on safely" }
        null
    }
}

/**
 * Safely execute the given [block] within a try-catch guard.
 * This will log any caught [Throwable] via [Fancam] and
 * returns `null` if an error occurs.
 *
 * @param block The block of code to run.
 * @param R The return type of block.
 * @return The result of [block] or `null` if an exception was thrown.
 */
suspend fun <R> safelySuspend(block: suspend () -> R): R? {
    return try {
        block()
    } catch (t: Throwable) {
        Fancam.error(t) { "Scandal detected on safelySuspend" }
        null
    }
}
