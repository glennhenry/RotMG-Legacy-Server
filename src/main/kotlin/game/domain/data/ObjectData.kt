package game.domain.data

import game.socket.outgoing.OutgoingMessage
import java.io.DataOutputStream

data class ObjectData(val objectType: Int, val status: ObjectStatusData) : OutgoingMessage {
    override fun write(output: DataOutputStream) {
        output.writeShort(objectType)
        status.write(output)
    }
}
