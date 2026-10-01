package game.domain.world.gameplay

import game.socket.outgoing.OutgoingMessage
import java.io.DataOutputStream

class DamageMessage(
    val targetId: Int,
    val effects: List<Int>, // probably debuff
    val damage: Int, // damage to player
    val kill: Boolean, // probably whether player is dead after this
    val bulletId: Int,
    val objectId: Int
) : OutgoingMessage {
    override fun write(output: DataOutputStream) {
        output.writeInt(targetId)
        output.writeByte(effects.size)
        effects.forEach { output.writeByte(it) }
        output.writeShort(damage)
        output.writeBoolean(kill)
        output.writeByte(bulletId)
        output.writeInt(objectId)
    }
}
