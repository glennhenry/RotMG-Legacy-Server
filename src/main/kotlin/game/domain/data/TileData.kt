package game.domain.data

import game.socket.outgoing.OutgoingMessage
import java.io.DataOutputStream

data class TileData(val x: Int, val y: Int, val type: Int) : OutgoingMessage {
    override fun write(output: DataOutputStream) {
        output.writeShort(x)
        output.writeShort(y)
        output.writeShort(type) // ushort
    }
}
