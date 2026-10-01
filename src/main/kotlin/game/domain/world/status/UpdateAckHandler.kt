package game.domain.world.status

import encore.fancam.Fancam
import encore.network.handler.FanchantHandler
import encore.network.handler.HandlerContext
import game.context.ServerContext
import game.socket.RotmgMessageIds

class UpdateAckHandler(private val serverContext: ServerContext) : FanchantHandler<UpdateAckFanchant> {
    override val fanchantType: String = RotmgMessageIds.UPDATEACK.toString()

    override suspend fun handle(ctx: HandlerContext<UpdateAckFanchant>) = with(ctx) {
        Fancam.debug { "Update ACK received" }
    }
}
