package game.domain.world.status

import game.socket.RotmgMessageIds
import game.socket.fanchant.RotmgFanchant
import game.utils.autoToString
import java.io.DataInputStream

class LoadFanchant : RotmgFanchant {
    override val type: String = RotmgMessageIds.LOAD.toString()

    var charId: Int = 0
    var isFromArena: Boolean = false

    override fun readBytes(bytes: DataInputStream) {
        charId = bytes.readInt()
        isFromArena = bytes.readBoolean()
    }

    override fun toString(): String {
        return this.autoToString()
    }
}
