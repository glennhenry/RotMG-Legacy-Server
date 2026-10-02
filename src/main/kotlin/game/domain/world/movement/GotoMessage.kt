package game.domain.world.movement

import game.socket.outgoing.OutgoingMessage
import java.io.DataOutputStream

class GotoMessage(val objectId: Int, val x: Float, val y:Float) : OutgoingMessage {
    override fun write(output: DataOutputStream) {
        output.writeInt(objectId)
        output.writeFloat(x)
        output.writeFloat(y)
    }
}
