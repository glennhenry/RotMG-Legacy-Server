package game.domain.world

import game.domain.data.ObjectStatusData
import game.socket.outgoing.OutgoingMessage
import java.io.DataOutputStream

class NewTickMessage(
    val tickId: Int,
    val tickTime: Int,
    val statuses: List<ObjectStatusData>
) : OutgoingMessage {
    override fun write(output: DataOutputStream) {
        output.writeInt(tickId)
        output.writeInt(tickTime)
        output.writeShort(statuses.size)
        statuses.forEach { it.write(output) }
    }
}
