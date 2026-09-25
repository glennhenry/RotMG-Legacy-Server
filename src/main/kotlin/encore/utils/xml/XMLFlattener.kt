package encore.utils.xml

import encore.fancam.Fancam
import encore.fancam.Tags
import org.w3c.dom.Element
import org.xml.sax.InputSource
import java.io.File
import java.io.StringReader
import javax.xml.parsers.DocumentBuilderFactory
import kotlin.collections.iterator

/**
 * XML utility to flatten an XML file into a flat key-value map whose key
 * is a dot-separated string between each XML tag's name.
 *
 * See [flatten].
 */
class XMLFlattener {
    /**
     * Flatten an XML structure into a flat key-value map.
     *
     * For instance:
     * ```xml
     * <parent enabled="true">
     *     <child>123</child>
     * </parent>
     * ```
     *
     * parsed to:
     * - `parent._enabled` = `true`
     * - `parent.child` = `123`
     *
     * @throws IllegalArgumentException When XML does not contain root element
     *                                  or when it has duplicate key.
     */
    fun flatten(xmlFile: File, xmlRoot: String): Map<String, String> {
        Fancam.trace(Tags.Xml) { "Parsing ${xmlFile.name}; root='$xmlRoot'" }

        val builder = DocumentBuilderFactory.newInstance().newDocumentBuilder()
        val doc = builder.parse(InputSource(StringReader(xmlFile.readText())))

        val root = doc.documentElement
            ?: throw IllegalArgumentException("XML does not contain a root element")
        if (root.nodeName != xmlRoot) {
            throw IllegalArgumentException("It's expected that the root XML tag is $xmlRoot")
        }

        return parseNode(xmlRoot, root).also {
            Fancam.trace(Tags.Xml) { "Parsed ${it.size} entries from ${xmlFile.name}" }
        }
    }

    /**
     * Parse individual node, recursively, returning map of each XML path to the value.
     *
     * For instance:
     * ```xml
     * <parent enabled="true">
     *     ...child
     * </parent>
     * ```
     *
     * parsed to:
     * - `parent._enabled` = `true`
     *
     * @throws IllegalStateException When XML contains duplicate key.
     */
    private fun parseNode(
        path: String,
        element: Element
    ): MutableMap<String, String> {
        val result = mutableMapOf<String, String>()
        val children = element.childNodes

        // attributes
        for (i in 0 until element.attributes.length) {
            val attr = element.attributes.item(i)

            val key = "$path._${attr.nodeName}"
            val value = attr.nodeValue

            Fancam.trace(Tags.Xml) { "Attribute $key='$value'" }

            result[key] = value
        }

        val elementChildren = (0 until children.length)
            .mapNotNull { children.item(it) as? Element }

        // leaf node value
        if (elementChildren.isEmpty()) {
            val value = element.textContent.trim()
            if (value.isNotEmpty()) {
                Fancam.trace(Tags.Xml) { "Value $path='$value'" }
                result[path] = value
            }
        }

        // recurse children
        for (child in elementChildren) {
            val childPath = "$path.${child.nodeName}"

            val childMap = parseNode(childPath, child)

            for ((k, v) in childMap) {
                if (k in result) {
                    throw IllegalStateException("Duplicate config key detected: $k")
                }
                result[k] = v
            }
        }

        return result
    }
}
