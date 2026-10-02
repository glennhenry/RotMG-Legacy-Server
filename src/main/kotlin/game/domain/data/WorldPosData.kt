package game.domain.data

import game.socket.outgoing.OutgoingMessage
import java.io.DataInputStream
import java.io.DataOutputStream

data class WorldPosData(val x: Float, val y: Float) : OutgoingMessage {
    override fun write(output: DataOutputStream) {
        output.writeFloat(x)
        output.writeFloat(y)
    }

    companion object {
        fun readBytes(bytes: DataInputStream): WorldPosData {
            return WorldPosData(
                x = bytes.readFloat(),
                y = bytes.readFloat()
            )
        }
    }
}
