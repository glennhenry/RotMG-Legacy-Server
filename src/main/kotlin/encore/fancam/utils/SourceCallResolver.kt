package encore.fancam.utils

import encore.fancam.events.TraceElement
import encore.fancam.events.toTraceElement
import kotlin.jvm.optionals.getOrNull

/**
 * Responsible for finding the source file and line number of a method call for callers.
 *
 * Use [resolve].
 *
 * @property filters List of package names to ignore. Defaults to [defaultFilters].
 */
class SourceCallResolver(val filters: List<String> = defaultFilters) {
    private val walker = StackWalker.getInstance()

    /**
     * Returns the [TraceElement] of current the thread call.
     *
     * This will also filter the ignored package name from [filters].
     */
    fun resolve(): TraceElement? {
        return walker.walk { frames ->
            frames
                .dropWhile { isFiltered(it.className) }
                .findFirst()
                .getOrNull()
        }?.toStackTraceElement()?.toTraceElement()
    }

    private fun isFiltered(className: String): Boolean {
        return filters.any { filter -> className.startsWith(filter)  }
    }
}

/**
 * List of package name to ignores which includes system internal
 * packages like Kotlin's coroutine and Java's thread; as well as
 * framework's internal like fancam and screening.
 */
val defaultFilters = listOf(
    "kotlin.coroutines",
    "encore.fancam",
    "encore.security.screening",
    "kotlinx.coroutines",
    "java.lang.Thread",
    "java.util.concurrent"
)
