package game.domain.world.gameplay

import game.socket.outgoing.OutgoingMessage
import java.io.DataOutputStream
import java.io.File

/**
 * Outgoing message `MapInfo` 58
 */
class MapInfoMessage(
    val width: Int, val height: Int, val name: String,
    val displayName: String, val fp: UInt, val background: Int,
    val difficulty: Int, val allowTeleport: Boolean, val showDisplay: Boolean,
    val xmlFiles: List<File>, val extraXmlFiles: List<File>
) : OutgoingMessage {
    override fun write(output: DataOutputStream) {
        output.writeInt(width)
        output.writeInt(height)
        output.writeUTF(name)
        output.writeUTF(displayName)
        output.writeInt(fp.toInt()) // uint
        output.writeInt(background)
        output.writeInt(difficulty)
        output.writeBoolean(allowTeleport)
        output.writeBoolean(showDisplay)

        // the number of XML files
        output.writeShort(xmlFiles.size)
        for (xmlFile in xmlFiles) {
            // size of XML file (can't be more than 2.1 mb)
            output.writeInt(xmlFile.length().toInt())

            // XML content
            output.writeBytes(xmlFile.readText())
        }

        // the number of extra XML files
        output.writeShort(extraXmlFiles.size)
        for (xmlFile in extraXmlFiles) {
            // size of XML file (can't be more than 2.1 mb)
            output.writeInt(xmlFile.length().toInt())

            // XML content
            output.writeBytes(xmlFile.readText())
        }
    }
}
