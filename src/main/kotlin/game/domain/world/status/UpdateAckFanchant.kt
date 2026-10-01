package game.domain.world.status

import game.socket.RotmgMessageIds
import game.socket.fanchant.RotmgFanchant
import java.io.DataInputStream

/**
 * The `UpdateAck` is an empty message sent by client.
 * Its only purpose is to "ACK" acknowledge that the client received the update message.
 */
class UpdateAckFanchant : RotmgFanchant {
    override val type: String = RotmgMessageIds.UPDATEACK.toString()
    override fun readBytes(bytes: DataInputStream) {}
    override fun toString(): String = "Update ACK ID=37 (empty)"
}
