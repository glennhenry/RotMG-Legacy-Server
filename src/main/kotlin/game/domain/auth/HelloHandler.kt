package game.domain.auth

import encore.network.handler.FanchantHandler
import encore.network.handler.HandlerContext
import game.domain.world.gameplay.MapInfoMessage
import game.socket.RotmgMessageIds
import game.socket.outgoing.createMessage
import java.io.File

class HelloHandler : FanchantHandler<HelloFanchant> {
    override val fanchantType: String = RotmgMessageIds.HELLO.toString()

    override suspend fun handle(ctx: HandlerContext<HelloFanchant>) = with(ctx) {
        val xmlDir = requireNotNull(File("assets/game/xml").listFiles()) { "Fatal: XML dir doesn't exist" }
        val extraXmlDir = requireNotNull(File("assets/game/xmlc").listFiles()) { "Fatal: XMLC dir doesn't exist" }
        val assetsList = xmlDir.filter { it.extension == "xml" }
        val extraAssetsList = extraXmlDir.filter { it.extension == "xml" }

        val msg = MapInfoMessage(
            width = 200,
            height = 200,
            name = "Nexus",
            displayName = "Nexus",
            fp = 123.toUInt(),
            background = 2,
            difficulty = 0,
            allowTeleport = true,
            showDisplay = true,
            xmlFiles = assetsList,
            extraXmlFiles = extraAssetsList
        )

        connection.write(createMessage(RotmgMessageIds.MAPINFO, msg))
    }
}
