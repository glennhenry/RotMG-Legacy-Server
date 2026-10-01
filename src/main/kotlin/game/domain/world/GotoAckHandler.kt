package game.domain.world

import encore.network.handler.FanchantHandler
import encore.network.handler.HandlerContext
import game.socket.RotmgMessageIds
import game.socket.outgoing.createMessage

class GotoAckHandler : FanchantHandler<GotoAckFanchant> {
    override val fanchantType: String = RotmgMessageIds.GOTOACK.toString()

    override suspend fun handle(ctx: HandlerContext<GotoAckFanchant>) = with(ctx) {
        val msg = GotoMessage(0, 50, 50)
        connection.write(createMessage(RotmgMessageIds.GOTOACK, msg))
    }
}
