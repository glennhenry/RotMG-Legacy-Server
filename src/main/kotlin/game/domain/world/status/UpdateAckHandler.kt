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

//        if (connection.get("tickrun") == null) {
//            serverContext.stageActDirector.run(
//                act = ForeverTimerAct(),
//                concept = ForeverTimerConcept(
//                    initialDelay = 0.seconds,
//                    interval = 1.seconds
//                ) {
//                    val msg = createMessage(
//                        messageId = RotmgMessageIds.NEWTICK,
//                        outgoing = NewTickMessage(
//                            tickId = it,
//                            tickTime = it,
//                            statuses = emptyList()
//                        )
//                    )
//                    connection.write(msg)
//                },
//                scope = ActScope(connection.address, connection.connectionScope)
//            )
//            connection.put("tickrun", true)
//        }
    }
}
