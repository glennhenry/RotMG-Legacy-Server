package encoreTest.fancam

import encore.EncoreFancamConfig
import encore.fancam.Fancam
import encore.fancam.events.Level
import encore.fancam.impl.FancamTemplate
import encore.fancam.impl.OfficialFancam
import kotlin.test.Test

/**
 * Only test the logger display, not actual code unit tests.
 *
 * use this to show color
 * ./gradlew test --tests "encoreTest.fancam.FancamDisplayTest.<test function>" --console=plain
 * for example:
 * ./gradlew test --tests "encoreTest.fancam.FancamDisplayTest" --console=plain
 * ./gradlew test --tests "encoreTest.fancam.FancamDisplayTest.fancam with color" --console=plain
 */
class FancamDisplayTest {
    @Test
    fun `fancam without color`() {
        val fancam = OfficialFancam(EncoreFancamConfig(colorEnabled = false))
        Fancam.initialize(fancam)
        logExample(fancam)
    }

    @Test
    fun `fancam with foreground color`() {
        val fancam = OfficialFancam(EncoreFancamConfig(useBackgroundColor = false))
        Fancam.initialize(fancam)
        logExample(fancam)
    }

    @Test
    fun `fancam with color`() {
        val fancam = OfficialFancam(EncoreFancamConfig())
        Fancam.initialize(fancam)
        logExample(fancam)
    }

    @Test
    fun `fancam route to file`() {
        // expected file: FancamDisplayTest-1.log
        // this will kept appending to the file
        // file rotation is enabled automatically

        val fancam = OfficialFancam(EncoreFancamConfig())
        Fancam.initialize(fancam)

        Fancam.event(Level.Trace, "tag1")
            .message { "This is an example of a trace message" }
            .logToFileOnly("FancamDisplayTest")

        Fancam.event(Level.Debug, "")
            .message { "Another one is a debug message which doesn't have tag" }
            .logToFileOnly("FancamDisplayTest")

        Fancam.event(Level.Info, "tag2")
            .message { "Info is usually used to announce server updates to server operator" }
            .logToFileOnly("FancamDisplayTest")

        Fancam.event(Level.Warn, "longtag")
            .message { "Warn is for odd behavior. Anyway this would print into console and output to file." }
            .setFileTarget("FancamDisplayTest")
            .log()

        Fancam.event(Level.Error, "smalltag")
            .message { "This is an example of error with exception alos being outputted." }
            .setThrowable(Exception("Example exception", RuntimeException("cause of the example")))
            .logToFileOnly("FancamDisplayTest")

        Fancam.event(Level.Warn, "xiaoting xiaoting xiaoting xiaoting")
            .message { "Xiaoting is so attractive. I keep thinking about her. I think I have fallen?" }
            .logToFileOnly("FancamDisplayTest")

    }

    @Test
    fun `fancam track event`() {
        val fancam = OfficialFancam(EncoreFancamConfig())
        Fancam.initialize(fancam)
        Fancam.track("TrackEventTest")
            .data("playerId", "pid12345")
            .data("completeAt", 12345678)
            .data("Triple", Triple("s", "s", "s"))
            .data("Liz", listOf("Liz"))
            .data("Complex data", EncoreFancamConfig())
            .note { "This is a test track" }
            .route("TrackEventTest")
            .record()
            .log(level = Level.Info)
    }

    private fun logExample(fancam: FancamTemplate) {
        fancam.trace("TestTag") { "This is an example of 'Fancam.trace' message with custom tag with custom tag (1)." }
        fancam.trace { "This is an example of 'Fancam.trace' message (1)." }
        fancam.debug("TestTag") { "This is an example of 'Fancam.debug' message with custom tag with custom tag (1)." }
        fancam.debug { "This is an example of 'Fancam.debug' message (1)." }
        fancam.info("TestLongLongLongTag") { "This is an example of 'Fancam.info' message with custom tag with custom tag (1)." }
        fancam.info { "This is an example of 'Fancam.info' message (1)." }
        fancam.warn("TestTag") { "This is an example of 'Fancam.warn' message with custom tag with custom tag (1)." }
        fancam.warn { "This is an example of 'Fancam.warn' message (1)." }
        fancam.error(
            Exception("Example exception", RuntimeException("cause of the example")),
            "TestTag"
        ) { "This is an example of 'Fancam.error' message with custom tag with custom tag (1)." }
        fancam.error { "This is an example of 'Fancam.error' message (1)." }
    }
}
