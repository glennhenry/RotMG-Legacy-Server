package example

import game.context.PlayerSubunits
import game.context.ServerContext
import game.mongo.collection.PlayerAccount
import encore.network.transport.TestConnection
import encore.network.handler.HandlerContext
import encore.network.handler.FanchantHandler
import encore.network.fanchant.Fanchant
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.test.StandardTestDispatcher
import kotlinx.coroutines.test.runTest
import testUtils.HandlerTestState
import testUtils.createAccount
import kotlin.reflect.KClass
import kotlin.test.Test
import kotlin.test.assertEquals

/**
 * Demonstrates how to test a fanchant handler.
 *
 * Why test handler?
 * - Ensure handler still works correctly (e.g., may test handler by a recorded packets).
 * - Ensure handler still work on weird condition (e.g., valid but weird payload).
 * - Integration test with subunit classes.
 * - Testing conditions that are hard to achieve realistically. Handler test harness
 *   the power to modify server context, subunits, and other components.
 *
 * This test setup relies on [TestConnection] to inject arbitrary incoming messages
 * and to inspect the outgoing messages produced by handlers.
 *
 * Typically, tests manipulate the server and player state — including [ServerContext],
 * [PlayerAccount], and [PlayerSubunits]. Some fields or components can remain default or empty
 * if they are not relevant to the current test scenario.
 *
 * For classes like subunits that depend on repository interfaces, initialize concrete
 * subunit with fake repository implementations that has predefined data and operations.
 * This allows isolated and flexible testing without requiring a live database or real dependencies.
 *
 * When validating the test results, you must manually deserialize the messages sent by handlers.
 * This is because handlers typically perform their own serialization. You may alternatively
 * serialize the expected value, but both approaches assume that the serializer and deserializer
 * behave correctly.
 */
class ExampleHandlerTest {
    @Test
    fun testHandler1() = runTest {
        val playerId = "pid123"
        val playerName = "player123"

        val state = HandlerTestState(
            playerId = playerId,
            playerName = playerName,
            message = DotSeparatedFanchant(payload = "MSG1.EX.hello.world.kotlin.ktor"),
            account = createAccount(playerId, playerName, "anypassword"),
            subunits = PlayerSubunits(),
            connectionScope = CoroutineScope(StandardTestDispatcher())
        )

        val handler = DotSeparatedHandler()
        handler.handle(state.handlerContext)

        val expected = "RESPONSE.EX.HELLOWORLDKOTLINKTOR"
        val bytesSend = state.connection.getOutgoing()
        val deserialized = bytesSend.first().decodeToString()
        assertEquals(expected, deserialized)
    }

    @Test
    fun testHandler2() = runTest {
        val playerId = "pid123"
        val playerName = "player123"

        val state = HandlerTestState(
            playerId = playerId,
            playerName = playerName,
            message = DotSeparatedFanchant(payload = "MSG1.EX.hello.world.kotlin|ktor"),
            account = createAccount(playerId, playerName, "anypassword"),
            subunits = PlayerSubunits(),
            connectionScope = CoroutineScope(StandardTestDispatcher())
        )

        val handler = DotSeparatedHandler()
        handler.handle(state.handlerContext)

        val expected = "RESPONSE.EX.FAIL"
        val bytesSend = state.connection.getOutgoing()
        val deserialized = bytesSend.first().decodeToString()
        assertEquals(expected, deserialized)
    }
}

/**
 * Example of handler that handles [DotSeparatedFanchant]
 */
class DotSeparatedHandler : FanchantHandler<DotSeparatedFanchant> {
    override val fanchantType: String = "EX"
    override val expectedFanchantClass: KClass<DotSeparatedFanchant> = DotSeparatedFanchant::class

    /**
     * `with(ctx)` gives developer QoL to access `connection` and `message` simpler.
     */
    override suspend fun handle(ctx: HandlerContext<DotSeparatedFanchant>) = with(ctx) {
        if (fanchant.payload.contains("|")) {
            val messageToSend = "RESPONSE.EX.FAIL"
            ctx.connection.write(messageToSend.toByteArray())
        } else {
            val cleanPayload = fanchant.payload.substringAfter("MSG1.EX.").split(".")
            val result = StringBuilder()

            cleanPayload.forEach { msg ->
                result.append(msg.uppercase())
            }

            val messageToSend = "RESPONSE.EX.$result"
            ctx.connection.write(messageToSend.toByteArray())
        }
    }
}

/**
 * Example of fanchant where payload is a `String` delimited by `.`.
 *
 * In real scenario, the [payload] may be a `List<String>` combined
 * with a message format implementation. It's omitted for simplicity.
 *
 * - First word is message version.
 * - Second word is message type.
 * - The rest are payload.
 */
class DotSeparatedFanchant(val payload: String) : Fanchant {
    override val type: String = "EX"
    override fun toString(): String = payload
}
