package game.domain.world

import encore.fancam.Fancam
import encore.network.handler.FanchantHandler
import encore.network.handler.HandlerContext
import game.socket.RotmgMessageIds

class UpdateAckHandler : FanchantHandler<UpdateAckFanchant> {
    override val fanchantType: String = RotmgMessageIds.UPDATEACK.toString()

    override suspend fun handle(ctx: HandlerContext<UpdateAckFanchant>) {
        Fancam.debug { "Update ACK received" }
    }
}
