package game.domain.world.gameplay

import game.socket.RotmgMessageIds
import game.socket.fanchant.RotmgFanchant
import game.utils.autoToString
import java.io.DataInputStream

class ShootAckFanchant : RotmgFanchant {
    override val type: String = RotmgMessageIds.SHOOTACK.toString()

    var time = 0

    override fun readBytes(bytes: DataInputStream) {
        time = bytes.readInt()
    }

    override fun toString(): String {
        return this.autoToString()
    }
}
