package game.domain.world

import encore.network.handler.FanchantHandler
import encore.network.handler.HandlerContext
import game.socket.RotmgMessageIds

class LoadHandler: FanchantHandler<LoadFanchant> {
    override val fanchantType: String = RotmgMessageIds.LOAD.toString()

    override suspend fun handle(ctx: HandlerContext<LoadFanchant>) = with(ctx) {


    }
}
