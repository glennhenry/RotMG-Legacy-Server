package game.domain.others

import game.socket.outgoing.OutgoingMessage
import java.io.DataOutputStream

/**
 * Outgoing message `Ping` 38
 */
class PingMessage : OutgoingMessage {
    override fun write(output: DataOutputStream) {
        output.writeInt(1)
    }
}
