package game.domain.handshake

import encore.network.handler.FanchantHandler
import encore.network.handler.HandlerContext
import game.domain.others.MapInfoMessage
import game.socket.RotmgMessageIds
import game.socket.outgoing.createMessage

class HelloHandler : FanchantHandler<HelloFanchant> {
    override val fanchantType: String = RotmgMessageIds.HELLO.toString()

    override suspend fun handle(ctx: HandlerContext<HelloFanchant>) = with(ctx) {
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
            xmlFiles = emptyList(),
            extraXmlFiles = emptyList()
        )

        connection.write(createMessage(RotmgMessageIds.MAPINFO, msg))
    }
}


