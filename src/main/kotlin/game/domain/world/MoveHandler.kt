package game.domain.world

import encore.fancam.Fancam
import encore.fancam.INDENT
import encore.network.handler.FanchantHandler
import encore.network.handler.HandlerContext
import game.socket.RotmgMessageIds

class MoveHandler : FanchantHandler<MoveFanchant> {
    override val fanchantType: String = RotmgMessageIds.MOVE.toString()

    override suspend fun handle(ctx: HandlerContext<MoveFanchant>) = with(ctx) {
        fanchant.time
        Fancam.debug {
            buildString {
                appendLine(
                    "Received Move(" +
                            "tickId=${fanchant.tickId}, " +
                            "time=${fanchant.time}, " +
                            "newPos=${fanchant.newPos}, " +
                            "records(last 3)=${fanchant.moveRecords.takeLast(3).joinToString()})"
                )
            }
        }
    }
}
