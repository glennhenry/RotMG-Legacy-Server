package game.domain.world.movement

import game.socket.outgoing.OutgoingMessage
import java.io.DataOutputStream

class GotoMessage(val objectId: Int, val x: Int, val y: Int) : OutgoingMessage {
    override fun write(output: DataOutputStream) {
        output.writeInt(objectId)
        output.writeFloat(x.toFloat())
        output.writeFloat(y.toFloat())
    }
}
