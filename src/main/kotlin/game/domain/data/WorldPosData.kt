package game.domain.data

import game.socket.outgoing.OutgoingMessage
import java.io.DataOutputStream

data class WorldPosData(val x: Int, val y: Int) : OutgoingMessage {
    override fun write(output: DataOutputStream) {
        output.writeFloat(x.toFloat())
        output.writeFloat(y.toFloat())
    }
}
