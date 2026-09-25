package encoreTest.fancam

import encore.fancam.events.Level
import encore.fancam.impl.RehearsalFancam
import org.junit.Test
import kotlin.test.assertFailsWith
import kotlin.test.assertTrue

class RehearsalFancamTest {
    @Test
    fun `log events recorded in their respective storage`() {
        val fancam = RehearsalFancam()

        fancam.trace { "Trace" }
        fancam.debug { "Debug" }
        fancam.info { "Info" }
        fancam.warn { "Warn" }
        fancam.error { "Error" }

        assertTrue {
            val logs = fancam.takeLastLogTrace(1)
            logs.first().message() == "Trace"
        }
        assertTrue {
            val logs = fancam.takeLastLogDebug(1)
            logs.first().message() == "Debug"
        }
        assertTrue {
            val logs = fancam.takeLastLogInfo(1)
            logs.first().message() == "Info"
        }
        assertTrue {
            val logs = fancam.takeLastLogWarn(1)
            logs.first().message() == "Warn"
        }
        assertTrue {
            val logs = fancam.takeLastLogError(1)
            logs.first().message() == "Error"
        }
    }

    @Test
    fun `track events recorded in their respective storage`() {
        val fancam = RehearsalFancam()

        fancam.track("TraceTrack").log(Level.Trace)
        fancam.track("DebugTrack").log(Level.Debug)
        fancam.track("InfoTrack").log(Level.Info)
        fancam.track("WarnTrack").log(Level.Warn)
        fancam.track("ErrorTrack").log(Level.Error)

        assertTrue {
            val logs = fancam.takeLastLogTrace(1)
            val tracks = fancam.takeLastTrackTrace(1)
            logs.isEmpty() && tracks.first().name == "TraceTrack"
        }
        assertTrue {
            val logs = fancam.takeLastLogDebug(1)
            val tracks = fancam.takeLastTrackDebug(1)
            logs.isEmpty() && tracks.first().name == "DebugTrack"
        }
        assertTrue {
            val logs = fancam.takeLastLogInfo(1)
            val tracks = fancam.takeLastTrackInfo(1)
            logs.isEmpty() && tracks.first().name == "InfoTrack"
        }
        assertTrue {
            val logs = fancam.takeLastLogWarn(1)
            val tracks = fancam.takeLastTrackWarn(1)
            logs.isEmpty() && tracks.first().name == "WarnTrack"
        }
        assertTrue {
            val logs = fancam.takeLastLogError(1)
            val tracks = fancam.takeLastTrackError(1)
            logs.isEmpty() && tracks.first().name == "ErrorTrack"
        }
    }

    @Test
    fun `assertLogHas work as expected`() {
        val fancam = RehearsalFancam()

        fancam.trace { "Trace1" }

        assertTrue {
            fancam.assertLogHas(Level.Trace, 1) { it.message() == "Trace1" }
        }

        fancam.trace { "Trace2" }
        fancam.trace { "Trace3" }
        fancam.trace { "Trace4" }

        println(fancam.takeLastLogTrace(4).joinToString())

        assertFailsWith<AssertionError> {
            fancam.assertLogHas(Level.Trace, 3) { it.message() == "Trace1" }
        }
    }

    @Test
    fun `assertTrackHas work as expected`() {
        val fancam = RehearsalFancam()

        fancam.track("Trace").data("trace1", 1).log(Level.Trace)

        assertTrue {
            fancam.assertTrackHas(Level.Trace, 1) { it.contains("trace1") }
        }

        fancam.track("Trace").data("trace2", 1).log(Level.Trace)
        fancam.track("Trace").data("trace3", 1).log(Level.Trace)
        fancam.track("Trace").data("trace4", 1).log(Level.Trace)

        assertFailsWith<AssertionError> {
            fancam.assertTrackHas(Level.Trace, 3) { it.contains("trace1") }
        }
    }
}
