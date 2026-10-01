package game.domain.account

import game.socket.outgoing.OutgoingMessage
import java.io.DataOutputStream

class CreateSuccessMessage(val objectId: Int, val charId: Int): OutgoingMessage {
    override fun write(output: DataOutputStream) {
        output.writeInt(objectId)
        output.writeInt(charId)
    }
}
