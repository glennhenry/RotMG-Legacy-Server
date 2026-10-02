package game.domain.world.movement

import encore.fancam.Fancam
import encore.network.handler.FanchantHandler
import encore.network.handler.HandlerContext
import game.socket.RotmgMessageIds
import game.socket.outgoing.createMessage

class GotoAckHandler : FanchantHandler<GotoAckFanchant> {
    override val fanchantType: String = RotmgMessageIds.GOTOACK.toString()

    override suspend fun handle(ctx: HandlerContext<GotoAckFanchant>) = with(ctx) {
        Fancam.debug { "GOTO_ACK received" }
    }
}
