package game.domain.character

import encore.network.handler.FanchantHandler
import encore.network.handler.HandlerContext
import game.domain.world.gameplay.MapInfoMessage
import game.socket.RotmgMessageIds
import game.socket.outgoing.createMessage

class CreateHandler : FanchantHandler<CreateFanchant> {
    override val fanchantType: String = RotmgMessageIds.CREATE.toString()

    override suspend fun handle(ctx: HandlerContext<CreateFanchant>) = with(ctx) {
        // objectId here = playerId
        val msg = CreateSuccessMessage(objectId = 1, charId = 1)
        connection.write(createMessage(RotmgMessageIds.CREATE_SUCCESS, msg))

        // resend mapinfo
        val msg2 = MapInfoMessage(
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

        connection.write(createMessage(RotmgMessageIds.MAPINFO, msg2))
    }
}
