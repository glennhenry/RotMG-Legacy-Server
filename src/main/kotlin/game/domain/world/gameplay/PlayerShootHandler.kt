package game.domain.world.gameplay

import encore.network.handler.FanchantHandler
import encore.network.handler.HandlerContext
import game.socket.RotmgMessageIds
import game.socket.outgoing.createMessage
import kotlin.random.Random

class PlayerShootHandler : FanchantHandler<PlayerShootFanchant> {
    override val fanchantType: String = RotmgMessageIds.PLAYERSHOOT.toString()

    override suspend fun handle(ctx: HandlerContext<PlayerShootFanchant>) = with(ctx) {
        val msg = ServerPlayerShootMessage(
            bulletId = fanchant.bulletId,
            ownerId = 1,
            containerType = fanchant.containerType,
            startPos = fanchant.startPos,
            angle = fanchant.angle,
            // this should be based on weapon's damage, atk stat
            // def is calculated by client
            damage = Random.nextInt(100, 150)
        )

        connection.put("lastbullet", fanchant.bulletId)

        connection.write(createMessage(RotmgMessageIds.SERVERPLAYERSHOOT, msg))
    }
}
