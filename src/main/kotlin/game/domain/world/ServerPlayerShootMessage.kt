package game.domain.world

import game.domain.data.WorldPosData
import game.socket.outgoing.OutgoingMessage
import java.io.DataOutputStream

// this is probably attack initiated by player,
// but the server do it instead such as wizard spell
class ServerPlayerShootMessage(
    val bulletId: Int,
    val ownerId: Int,
    val containerType: Int,
    val startPos: WorldPosData,
    val angle: Float,
    val damage: Int
) : OutgoingMessage {
    override fun write(output: DataOutputStream) {
        output.writeByte(bulletId)
        output.writeInt(ownerId)
        output.writeInt(containerType)
        startPos.write(output)
        output.writeFloat(angle)
        output.writeShort(damage)
    }
}
