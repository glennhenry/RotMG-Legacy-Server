package testUtils

import kotlin.test.Test
import kotlin.test.assertFailsWith

/**
 * Assert that the called [block] does not fail.
 *
 * @throws AssertionError
 */
fun <T> assertDoesNotFail(block: () -> T): T {
    try {
        return block()
    } catch (t: Throwable) {
        throw AssertionError("Expected block to not throw, but got: ${t::class.simpleName}: ${t.message}", t)
    }
}

/**
 * Assert that the called suspendable [block] does not fail.
 *
 * @throws AssertionError
 */
suspend fun <T> assertDoesNotFailSuspend(block: suspend () -> T): T {
    try {
        return block()
    } catch (t: Throwable) {
        throw AssertionError("Expected block to not throw, but got: ${t::class.simpleName}: ${t.message}", t)
    }
}

class AssertUtilsTest {
    @Test
    fun doesNotFail() {
        assertDoesNotFail {
            println("Not fail")
        }
    }

    @Test
    fun actuallyFailed() {
        assertFailsWith<AssertionError> {
            assertDoesNotFail {
                throw Exception("Failed")
            }
        }
    }
}
