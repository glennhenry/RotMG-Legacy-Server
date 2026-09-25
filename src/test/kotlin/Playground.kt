import testUtils.TestFancam
import kotlin.test.BeforeTest
import kotlin.test.Test

/**
 * Playground for quick testing and code run
 *
 * .\gradlew test --tests "Playground.play" --console=plain
 */
class Playground {
    @BeforeTest
    fun setup() {
        TestFancam.create()
    }

    @Test
    fun play() {
        println("")
    }
}
