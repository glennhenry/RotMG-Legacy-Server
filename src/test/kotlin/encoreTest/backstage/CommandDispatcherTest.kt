package encoreTest.backstage

import encore.backstage.command.Command
import encore.backstage.command.CommandDispatcher
import encore.backstage.command.types.ArgumentCollection
import encore.backstage.command.types.ArgumentDescriptor
import encore.backstage.command.types.CommandRequest
import encore.backstage.command.types.CommandResult
import encore.fancam.events.Level
import game.context.ServerContext
import kotlinx.coroutines.test.runTest
import testUtils.TestFancam
import testUtils.randomString
import kotlin.random.Random
import kotlin.test.*

/**
 * Command dispatcher test and example of command implementation [encoreTest.backstage.ExampleGiveCommand].
 *
 * Does not need to test invalid request since parser already validates that.
 */
class CommandDispatcherTest {
    private val context = ServerContext.createForTest()

    @BeforeTest
    fun setup() {
        TestFancam.create()
    }

    @Test
    fun `testCommandDispatcher register normal success`() = runTest {
        val dispatcher = CommandDispatcher()

        dispatcher.register(createCommand("cmd1"))
        dispatcher.register(createCommand("cmd2"))
        dispatcher.register(createCommand("cmd3"))
        dispatcher.getAllRegisteredCommandsId().containsAll(listOf("cmd1", "cmd2", "cmd3"))
    }

    @Test
    fun `testCommandDispatcher register duplicate commandId success but warned`() = runTest {
        val dispatcher = CommandDispatcher()

        dispatcher.register(createCommand("cmd1"))
        dispatcher.register(createCommand("cmd2"))
        dispatcher.register(createCommand("cmd2"))

        // ensure warned
        assertTrue {
            TestFancam.get().assertLogHas(Level.Warn, 1) { it.message().contains("has been registered before") }
        }

        // ensure the first registered command gets overwritten
        assertTrue(dispatcher.getAllRegisteredCommandsId().contains("cmd2"))
    }

    @Test
    fun `testCommandDispatcher register commandId blank 1 throws`() = runTest {
        val dispatcher = CommandDispatcher()

        assertFailsWith<IllegalArgumentException> {
            dispatcher.register(createCommand(""))
        }
    }

    @Test
    fun `testCommandDispatcher register commandId blank 2 throws`() = runTest {
        val dispatcher = CommandDispatcher()

        assertFailsWith<IllegalArgumentException> {
            dispatcher.register(createCommand("   "))
        }
    }

    @Test
    fun `testCommandDispatcher register commandId has invalid character 1 throws`() = runTest {
        val dispatcher = CommandDispatcher()

        assertFailsWith<IllegalArgumentException> {
            dispatcher.register(createCommand("@@@"))
        }
    }

    @Test
    fun `testCommandDispatcher register commandId has invalid character 2 throws`() = runTest {
        val dispatcher = CommandDispatcher()

        assertFailsWith<IllegalArgumentException> {
            dispatcher.register(createCommand("  @@@ "))
        }
    }

    @Test
    fun `testCommandDispatcher register commandId has acceptable character does not throws`() = runTest {
        val dispatcher = CommandDispatcher()
        dispatcher.register(createCommand("give-ext"))
    }

    @Test
    fun `testCommandDispatcher register commandId has whitespace character success`() = runTest {
        val dispatcher = CommandDispatcher()

        dispatcher.register(createCommand("   give-ext"))
        assertTrue(dispatcher.getAllRegisteredCommandsId().contains("give-ext"))
    }

    @Test
    fun `testCommandDispatcher register commandId duplicate name but different cases success`() = runTest {
        val dispatcher = CommandDispatcher()

        dispatcher.register(createCommand("give-ext"))
        dispatcher.register(createCommand("giVe-Ext"))
        dispatcher.register(createCommand("GIVE-EXT"))

        assertTrue(dispatcher.getAllRegisteredCommandsId().containsAll(listOf("give-ext", "giVe-Ext", "GIVE-EXT")))
    }

    @Test
    fun `testCommandDispatcher handleCommand unregistered command returns command not found`() = runTest {
        val dispatcher = CommandDispatcher()

        val request = CommandRequest("cmd", buildArgCollection {})
        val result = dispatcher.handleCommand(request, context)
        assertTrue(result is CommandResult.CommandNotFound)
    }

    @Test
    fun `testCommandDispatcher handleCommand normally 1 returns executed`() = runTest {
        val dispatcher = CommandDispatcher()
        dispatcher.register(ExampleGiveCommand())

        val request = CommandRequest(
            "give",
            buildArgCollection {
                add("userAbc")
                add("water")
            }
        )
        val result = dispatcher.handleCommand(request, context)
        assertTrue(result is CommandResult.Executed)
    }

    @Test
    fun `testCommandDispatcher handleCommand normally 2 returns executed`() = runTest {
        val dispatcher = CommandDispatcher()
        dispatcher.register(ExampleGiveCommand())

        val request = CommandRequest(
            "give",
            buildArgCollection {
                add("userAbc")
                add("water")
                add("100")
            }
        )
        val result = dispatcher.handleCommand(request, context)
        assertTrue(result is CommandResult.Executed)
    }

    @Test
    fun `testCommandDispatcher handleCommand insufficient arguments returns not enough argument`() = runTest {
        val dispatcher = CommandDispatcher()
        dispatcher.register(ExampleGiveCommand())

        val request = CommandRequest(
            "give",
            buildArgCollection {
                add("userABC")
            }
        )
        val result = dispatcher.handleCommand(request, context)
        assertTrue(result is CommandResult.NotEnoughArgument)
    }

    @Test
    fun `testCommandDispatcher handleCommand argument type mismatch returns invalid argument type`() = runTest {
        val dispatcher = CommandDispatcher()
        dispatcher.register(ExampleGiveCommand())

        val request = CommandRequest(
            "give",
            buildArgCollection {
                add("userABC")
                add("water")
                add("notNumber")
            }
        )
        val result = dispatcher.handleCommand(request, context)
        assertTrue(result is CommandResult.InvalidArgumentType)
    }

    @Test
    fun `testCommandDispatcher handleCommand simulates uncaught exception returns command error`() = runTest {
        val dispatcher = CommandDispatcher()
        dispatcher.register(ExampleGiveCommand())

        val request = CommandRequest(
            "give",
            buildArgCollection {
                add("userABC")
                add("water")
                add("2")
            }
        )
        val result = dispatcher.handleCommand(request, context)
        assertTrue(result is CommandResult.Error)
    }

    @Test
    fun `testCommandDispatcher handleCommand simulates failure returns execution failure`() = runTest {
        val dispatcher = CommandDispatcher()
        dispatcher.register(ExampleGiveCommand())

        val request = CommandRequest(
            "give",
            buildArgCollection {
                add("userABC")
                add("water")
                add("3")
            }
        )
        val result = dispatcher.handleCommand(request, context)
        assertTrue(result is CommandResult.ExecutionFailure)
    }

    @Test
    fun `testCommandDispatcher handleCommand too many arguments still success returns executed`() = runTest {
        val dispatcher = CommandDispatcher()
        dispatcher.register(ExampleGiveCommand())

        val request = CommandRequest(
            "give",
            buildArgCollection {
                add("userABC")
                add("water")
                add("4")
                add("4")
                add("a")
                add("b")
            }
        )
        val result = dispatcher.handleCommand(request, context)
        assertTrue(result is CommandResult.Executed)
    }

    private val charPool = ('a'..'z') + ('A'..'Z')
    private val typePool = setOf("String", "Int", "Boolean", "Double")

    private fun generateDescriptor(): ArgumentDescriptor {
        val id = randomString(Random.nextInt(4, 9), charPool)
        val desc = randomString(Random.nextInt(10, 30), charPool)
        val type = typePool.random()

        return ArgumentDescriptor(id, type, desc)
    }

    private fun generateDescriptors(): List<ArgumentDescriptor> {
        return List(Random.nextInt(1, 4)) {
            generateDescriptor()
        }
    }

    private fun createCommand(id: String): Command {
        return object : Command {
            override val commandId: String = id
            override val description: String = "TestCommand of $id"

            override suspend fun execute(serverContext: ServerContext, args: ArgumentCollection): CommandResult {
                return CommandResult.Executed("execute() called on command ($id)")
            }
        }
    }

    private fun buildArgCollection(block: MutableList<String>.() -> Unit): ArgumentCollection {
        val list = buildList(block)
        return ArgumentCollection(list)
    }
}
