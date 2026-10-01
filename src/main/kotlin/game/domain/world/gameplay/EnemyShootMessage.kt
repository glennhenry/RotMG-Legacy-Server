package game.domain.world.gameplay

import game.domain.data.WorldPosData
import game.socket.outgoing.OutgoingMessage
import java.io.DataOutputStream

class EnemyShootMessage(
    val bulletId: Int,
    val ownerId: Int,
    val bulletType: Int,
    val startPos: WorldPosData,
    val angle: Float,
    val damage: Int,
    val numShots: Int,
    val angleInc: Float
) : OutgoingMessage {
    override fun write(output: DataOutputStream) {
        output.writeByte(bulletId)
        output.writeInt(ownerId)
        output.writeByte(bulletType)
        startPos.write(output)
        output.writeFloat(angle)
        output.writeShort(damage)
        output.writeByte(numShots)
        output.writeFloat(angleInc)
    }
}
