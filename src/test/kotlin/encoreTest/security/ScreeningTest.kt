package encoreTest.security

import encore.EncoreFancamConfig
import encore.fancam.Fancam
import encore.fancam.impl.OfficialFancam
import encore.security.Screening
import kotlinx.coroutines.delay
import kotlinx.coroutines.test.runTest
import testUtils.assertDoesNotFail
import testUtils.assertDoesNotFailSuspend
import kotlin.test.BeforeTest
import kotlin.test.Test
import kotlin.test.assertFailsWith
import kotlin.test.assertFalse
import kotlin.test.assertTrue
import kotlin.time.Duration.Companion.milliseconds

class ScreeningTest {
    @BeforeTest
    fun setup() {
        Fancam.initialize(OfficialFancam(EncoreFancamConfig()))
    }

    @Test
    fun `screening should pass normally`() {
        val str = "HelloWorld Ktor"

        assertDoesNotFail {
            Screening("ScreeningTest", "Example")
                .check("Contains space", predicate = { str.contains(" ") }) {
                    throw AssertionError("Shouldn't fail here")
                }
                .check("Contains 'Ktor'", { str.contains("Ktor") }) {
                    throw AssertionError("Shouldn't fail here")
                }
        }
    }

    @Test
    fun `screening should fail at the expected stage and does not execute the next stage`() {
        val str = "HelloWorld Ktor"
        var fail = false

        Screening("ScreeningTest")
            .check("Contains space", { str.contains(" ") }) {
                throw AssertionError("Shouldn't fail here")
            }
            .check("Contains 'Kitty'", { str.contains("Kitty") }) {
                fail = true
            }
            .check("Contains 'Ktor'", { throw AssertionError("Shouldn't execute this") }) {
                throw AssertionError("Shouldn't fail here this")
            }

        assertTrue(fail)
    }

    @Test
    fun `screening includes suspendable function in checkSuspend should pass`() = runTest {
        val str = "HelloWorld Ktor"

        assertDoesNotFailSuspend {
            Screening("ScreeningTest")
                .checkSuspend("Contains space", {
                    delay(1000.milliseconds)
                    str.contains(" ")
                }) {
                    throw AssertionError("Shouldn't fail here")
                }
                .check("Contains 'Ktor'", { str.contains("Ktor") }) {
                    throw AssertionError("Shouldn't fail here")
                }
        }
    }

    @Test
    fun `screening throws an error in certain check should re-throw the expected exception and don't run onFail`() {
        val str = "HelloWorld Ktor"
        var onFailExecuted = false

        assertFailsWith<RuntimeException>(message = "Xiaoting") {
            Screening("ScreeningTest")
                .check("Contains space", { str.contains(" ") }) {
                    throw AssertionError("Shouldn't fail here")
                }
                .check("Contains 'Ktor'", { throw RuntimeException("Xiaoting") }) {
                    onFailExecuted = true
                }
                .check("Contains 'Ktor'", { throw AssertionError("Shouldn't execute this") }) {
                    throw AssertionError("Shouldn't fail here")
                }
        }

        assertFalse(onFailExecuted)
    }
}
