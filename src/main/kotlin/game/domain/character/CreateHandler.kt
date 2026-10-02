package game.domain.character

import encore.network.handler.FanchantHandler
import encore.network.handler.HandlerContext
import game.Globals
import game.domain.world.gameplay.MapInfoMessage
import game.socket.RotmgMessageIds
import game.socket.outgoing.createMessage

/**
 * `Create` represent the client initiation to enter a world.
 * This instrurcts the server to create player object and spawn them in the world.
 *
 * This is why the client expect an `objectId` for creating a character.
 * It's "probably" not creating a new character for your account, but
 * creating a player character object to enter the nexus.
 *
 * This means whether the character is created or not, to enter the nexus,
 * a `Create` request will always happen.
 */
class CreateHandler : FanchantHandler<CreateFanchant> {
    override val fanchantType: String = RotmgMessageIds.CREATE.toString()

    override suspend fun handle(ctx: HandlerContext<CreateFanchant>) = with(ctx) {
        // objectId here = playerId
        val msg = CreateSuccessMessage(objectId = Globals.PLAYER_OBJECT_ID, charId = 1)
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
