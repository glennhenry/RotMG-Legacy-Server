package encoreTest.utilsTest

import encore.utils.xml.XMLFlattener
import testUtils.toTempFile
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertFailsWith
import kotlin.test.assertTrue

class XMLFlattenerTest {
    @Test
    fun `normal XML success`() {
        val input = """
            <root>
                <parent1>
                    <child1 />
                </parent1>
                <parent2>
                    <child2>
                        <child3>value</child3>
                    </child2>
                </parent2>
            </root>
        """.trimIndent().toTempFile("venue.xml")

        val flattener = XMLFlattener()
        val map = flattener.flatten(input, "root")

        assertEquals("value", map["root.parent2.child2.child3"])
        assertTrue(map.containsKey("root.parent2.child2.child3"))
        assertEquals(1, map.size)
    }

    @Test
    fun `XML with attribute has _ key success`() {
        val input = """
            <root>
                <parent>
                    <child enabled="true" />
                </parent>
            </root>
        """.trimIndent().toTempFile("venue.xml")

        val flattener = XMLFlattener()

        val map = flattener.flatten(input, "root")

        assertEquals("true", map["root.parent.child._enabled"])
        assertEquals(1, map.size)
    }

    @Test
    fun `XML with duplicate key should throw`() {
        val input = """
            <root>
                <parent>
                    <child>
                        <value>1</value>
                    </child>
                    <child>
                        <value>2</value>
                    </child>
                </parent>
            </root>
        """.trimIndent().toTempFile("venue.xml")

        val flattener = XMLFlattener()

        assertFailsWith<IllegalStateException> {
            flattener.flatten(input, "root")
        }
    }

    @Test
    fun `XML mismatch between given root name than what is written`() {
        val input = """
            <root>
                <parent>
                    <child>
                        <value>1</value>
                    </child>
                    <child>
                        <value>2</value>
                    </child>
                </parent>
            </root>
        """.trimIndent().toTempFile("venue.xml")

        val flattener = XMLFlattener()

        assertFailsWith<IllegalArgumentException> {
            flattener.flatten(input, "venue")
        }
    }
}