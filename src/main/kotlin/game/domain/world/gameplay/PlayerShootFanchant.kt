package game.domain.world.gameplay

import game.domain.data.WorldPosData
import game.socket.RotmgMessageIds
import game.socket.fanchant.RotmgFanchant
import game.utils.autoToString
import java.io.DataInputStream

// shot attack initiated by player by input (left click)
class PlayerShootFanchant : RotmgFanchant {
    override val type: String = RotmgMessageIds.PLAYERSHOOT.toString()

    var time: Int = 0
    var bulletId: Int = 0
    var containerType: Int = 0
    var startPos: WorldPosData = WorldPosData(0f, 0f)
    var angle: Float = 0.0f

    override fun readBytes(bytes: DataInputStream) {
        time = bytes.readInt()
        bulletId = bytes.readByte().toInt()
        containerType = bytes.readShort().toInt()
        startPos = WorldPosData.readBytes(bytes)
        angle = bytes.readFloat()
    }

    override fun toString(): String {
        return this.autoToString()
    }
}
