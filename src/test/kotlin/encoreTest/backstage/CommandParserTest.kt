package encoreTest.backstage

import encore.backstage.command.types.ArgumentCollection
import encore.backstage.command.CommandParser
import encore.backstage.command.types.CommandRequest
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertFailsWith

class CommandParserTest {
    private val parser = CommandParser()

    private fun buildArgCollection(block: MutableList<String>.() -> Unit): ArgumentCollection {
        val list = buildList(block)
        return ArgumentCollection(list)
    }

    @Test
    fun `testParser input normal 1 success`() {
        val req = CommandRequest(
            "give",
            buildArgCollection {
                add("x")
                add("y")
            }
        )
        assertEquals(req, parser.parse("give x y"))
    }

    @Test
    fun `testParser input normal 2 success`() {
        val req = CommandRequest(
            "give",
            buildArgCollection {
                add("player_abc")
                add("y")
            }
        )
        assertEquals(req, parser.parse("give player_abc y"))
    }

    @Test
    fun `testParser input normal 3 success`() {
        val req = CommandRequest(
            "give",
            buildArgCollection {
                add("player-abc")
                add("y_s")
                add("-")
            }
        )
        assertEquals(req, parser.parse("give player-abc y_s -"))
    }

    @Test
    fun `testParser input normal 4 success`() {
        val req = CommandRequest(
            "a",
            buildArgCollection {
                add("b")
                add("c")
            }
        )
        assertEquals(req, parser.parse("a b c"))
    }

    @Test
    fun `testParser input normal 5 success`() {
        val req = CommandRequest(
            "1",
            buildArgCollection {
                add("2")
                add("3")
            }
        )
        assertEquals(req, parser.parse("1 2 3"))
    }

    @Test
    fun `testParser input contains no argument success`() {
        val req = CommandRequest(
            "clear",
            buildArgCollection {}
        )
        assertEquals(req, parser.parse("clear"))
    }

    @Test
    fun `testParser input weird but success`() {
        val req = CommandRequest(
            "-",
            buildArgCollection {
                add("-")
                add("_")
            }
        )
        assertEquals(req, parser.parse("- - _"))
    }

    @Test
    fun `testParser input starts with whitespace but success`() {
        val req = CommandRequest(
            "give",
            buildArgCollection {
                add("x")
                add("y")
            }
        )
        assertEquals(req, parser.parse("    give x y"))
    }

    @Test
    fun `testParser input end with whitespace but success`() {
        val req = CommandRequest(
            "give",
            buildArgCollection {
                add("x")
                add("y")
            }
        )
        assertEquals(req, parser.parse("give x y     "))
    }

    @Test
    fun `testParser input contains nothing fails`() {
        assertFailsWith<IllegalArgumentException> {
            parser.parse("")
        }
    }

    @Test
    fun `testParser input contains white space only fails`() {
        assertFailsWith<IllegalArgumentException> {
            parser.parse(" ")
        }
    }

    @Test
    fun `testParser input contains number only success`() {
        val req = CommandRequest(
            "123",
            buildArgCollection {}
        )
        assertEquals(req, parser.parse("123"))
    }

    @Test
    fun `testParser input contains invalid character 1 input fails`() {
        assertFailsWith<IllegalArgumentException> {
            parser.parse("give x y .")
        }
    }

    @Test
    fun `testParser input contains invalid character 2 input fails`() {
        assertFailsWith<IllegalArgumentException> {
            parser.parse("give x y ()")
        }
    }

    @Test
    fun `testParser input contains invalid character 3 input fails`() {
        assertFailsWith<IllegalArgumentException> {
            parser.parse("give x y {%")
        }
    }

    @Test
    fun `testParser input contains invalid unicode character 1 fails`() {
        assertFailsWith<IllegalArgumentException> {
            parser.parse("give playerㅧ y")
        }
    }

    @Test
    fun `testParser input contains invalid unicode character 2 fails`() {
        assertFailsWith<IllegalArgumentException> {
            parser.parse("ＰＬＡＹＥＲ ＰＬＡＹＥＲ")
        }
    }

    @Test
    fun `testParser input contains invalid unicode character 3 fails`() {
        assertFailsWith<IllegalArgumentException> {
            parser.parse("\uD83D\uDC80\uD83D\uDC80\uD83D\uDC80 \uD83D\uDC80\uD83D\uDC80\uD83D\uDC80")
        }
    }

    @Test
    fun `testParser input contains invalid unicode character 4 fails`() {
        assertFailsWith<IllegalArgumentException> {
            parser.parse("pl​ayer")
        }
    }
}
