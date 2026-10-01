package game.domain.world

import encore.network.handler.FanchantHandler
import encore.network.handler.HandlerContext
import game.socket.RotmgMessageIds

class PlayerShootHandler: FanchantHandler<PlayerShootFanchant> {
    override val fanchantType: String = RotmgMessageIds.PLAYERSHOOT.toString()

    override suspend fun handle(ctx: HandlerContext<PlayerShootFanchant>) = with(ctx) {

    }
}
