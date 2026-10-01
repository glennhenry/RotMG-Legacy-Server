package game.domain.data

import game.socket.outgoing.OutgoingMessage
import java.io.DataOutputStream
import kotlin.collections.forEach

data class ObjectStatusData(
    val objectId: Int,
    val pos: WorldPosData,
    val stats: List<StatData>
) : OutgoingMessage {
    override fun write(output: DataOutputStream) {
        output.writeInt(objectId)
        pos.write(output)
        output.writeShort(stats.size)
        stats.forEach { stat -> stat.write(output) }
    }
}
