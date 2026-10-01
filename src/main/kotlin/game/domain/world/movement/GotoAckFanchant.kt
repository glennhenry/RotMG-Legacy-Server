package game.domain.world.movement

import game.socket.RotmgMessageIds
import game.socket.fanchant.RotmgFanchant
import game.utils.autoToString
import java.io.DataInputStream

class GotoAckFanchant : RotmgFanchant {
    override val type: String = RotmgMessageIds.GOTOACK.toString()

    var time: Int = 0

    override fun readBytes(bytes: DataInputStream) {
        time = bytes.readInt()
    }

    override fun toString(): String {
        return this.autoToString()
    }
}
