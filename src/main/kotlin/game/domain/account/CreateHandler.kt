package game.domain.account

import encore.network.handler.FanchantHandler
import encore.network.handler.HandlerContext
import game.socket.RotmgMessageIds
import game.socket.outgoing.createMessage

class CreateHandler : FanchantHandler<CreateFanchant> {
    override val fanchantType: String = RotmgMessageIds.CREATE.toString()

    override suspend fun handle(ctx: HandlerContext<CreateFanchant>) = with(ctx) {
        val msg = CreateSuccessMessage(1, 1)
        connection.write(createMessage(RotmgMessageIds.CREATE_SUCCESS, msg))
    }
}
