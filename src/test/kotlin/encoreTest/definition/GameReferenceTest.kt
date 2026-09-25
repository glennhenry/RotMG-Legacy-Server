package encoreTest.definition

import encore.definition.GameDataLoader
import encore.definition.GameReference
import encore.definition.GameDataSource
import encore.definition.GameDefinition
import testUtils.assertDoesNotFail
import java.io.File
import kotlin.test.Test
import kotlin.test.assertEquals

/**
 * Aggregate tests for [GameReference] and examples of
 * - [GameDataSource]
 * - [GameDataLoader]
 * - [GameDefinition]
 *
 * Test points:
 * - [GameReference.initialize]
 * - [GameReference.get]
 * - GameReference's definition lookup
 *
 * Tests for data source or loader should be made separate.
 */
class GameReferenceTest {
    @Test
    fun `initialize and lookup game definitions works correctly`() {
        val tempResFile = File.createTempFile("test", ".ini").also { it.deleteOnExit() }
        tempResFile.writeText(
            """
            hello=1
            world=2
            kotlin=3
            ktor=4
        """.trimIndent()
        )

        val source = IniDataSource(tempResFile.path)
        val loader = IniDataLoader()

        GameReference.initialize {
            add(source, loader)
        }

        assertDoesNotFail {
            // uninitialized registry would throw error
            GameReference.registry.size
        }

        assertDoesNotFail {
            val definition = GameReference.get<PlainTextDefinition>()

            assertEquals(1, definition.get("hello"))
            assertEquals(2, definition.get("world"))
            assertEquals(3, definition.get("kotlin"))
            assertEquals(4, definition.get("ktor"))
            assertEquals(null, definition.get("asdf"))
        }
    }
}

/**
 * Example implementation of [GameDataSource] format.
 *
 * This file extension is ".ini" and it simply reads
 * the text without additional decoding.
 *
 * Generally, content retrieval goes through [readText].
 */
class IniDataSource(override val path: String) : GameDataSource {
    override fun readText(): String {
        return File(path).readText()
    }

    override fun readBytes(): ByteArray {
        return File(path).readBytes()
    }
}

/**
 * Example loader for the [IniDataSource] game resources.
 *
 * The `.ini` format is just "<property>=<number>".
 *
 * This loader only produces a single definition which is [PlainTextDefinition].
 */
class IniDataLoader : GameDataLoader {
    private val map = mutableMapOf<String, Int>()

    override fun produce(source: GameDataSource): List<GameDefinition> {
        val text = source.readText()
        for (line in text.lines()) {
            val group = line.split("=")
            if (group.size != 2) continue
            map[group[0]] = group[1].toInt()
        }
        return listOf(PlainTextDefinition(map))
    }
}

/**
 * Example implementation of [GameDefinition].
 *
 * In this case, the definition provides a lookup of value.
 */
class PlainTextDefinition(private val input: Map<String, Int>) : GameDefinition {
    fun get(key: String): Int? {
        return input[key]
    }
}
