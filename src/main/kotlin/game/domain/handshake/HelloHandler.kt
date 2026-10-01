package game.domain.handshake

import encore.network.handler.FanchantHandler
import encore.network.handler.HandlerContext
import game.domain.others.MapInfoMessage
import game.socket.RotmgMessageIds
import game.socket.outgoing.createMessage
import java.io.File

class HelloHandler : FanchantHandler<HelloFanchant> {
    override val fanchantType: String = RotmgMessageIds.HELLO.toString()

    override suspend fun handle(ctx: HandlerContext<HelloFanchant>) = with(ctx) {
        val assetsList = listOf(
            File("assets/game/xml/Objects.xml"),
            File("assets/game/xml/Pets.xml"),
            File("assets/game/xml/Players.xml"),
            File("assets/game/xml/StaticObjects.xml")
        )
        val extraAssetsList = listOf(
            File("assets/game/xmlc/Objects.xml"),
            File("assets/game/xmlc/Particles.xml"),
            File("assets/game/xmlc/Regions.xml"),
            File("assets/game/xmlc/GroundTypes.xml")
        )

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
