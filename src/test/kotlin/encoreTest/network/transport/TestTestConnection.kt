package encoreTest.network.transport

import encore.network.transport.ConnectionIdentity
import encore.network.transport.TestConnection
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.test.StandardTestDispatcher
import kotlinx.coroutines.test.runTest
import kotlin.test.Test
import kotlin.test.assertEquals

/**
 * To test the [encore.network.transport.TestConnection] class.
 */
class TestTestConnection {
    @Test
    fun testConnection() = runTest {
        val conn = TestConnection(
            connectionScope = CoroutineScope(StandardTestDispatcher()),
            identity = ConnectionIdentity(
                playerId = "p1",
                username = "Alice",
                remoteAddress = "N/A"
            )
        )
        conn.enqueueIncoming("Hello".toByteArray())

        val (_, bytes) = conn.read() // returns the injected message
        assertEquals("Hello", String(bytes))

        conn.write("World".toByteArray())
        assertEquals("World", String(conn.getOutgoing().first()))
    }
}
