package game.domain.world.gameplay

import encore.fancam.Fancam
import encore.network.handler.FanchantHandler
import encore.network.handler.HandlerContext
import game.socket.RotmgMessageIds

class ShootAckHandler: FanchantHandler<ShootAckFanchant> {
    override val fanchantType: String = RotmgMessageIds.SHOOTACK.toString()

    override suspend fun handle(ctx: HandlerContext<ShootAckFanchant>) {
        Fancam.debug { "Received SHOOT_ACK" }
    }
}
