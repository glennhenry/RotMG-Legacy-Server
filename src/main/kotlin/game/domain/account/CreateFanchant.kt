package game.domain.account

import game.socket.RotmgMessageIds
import game.socket.fanchant.RotmgFanchant
import game.utils.autoToString
import java.io.DataInputStream

class CreateFanchant : RotmgFanchant {
    override val type: String = RotmgMessageIds.CREATE.toString()

    var classType: Int = 0
    var skinType: Int = 0

    override fun readBytes(bytes: DataInputStream) {
        classType = bytes.readShort().toInt()
        skinType = bytes.readShort().toInt()
    }

    override fun toString(): String {
        return this.autoToString()
    }
}
