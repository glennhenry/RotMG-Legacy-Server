package game.domain.world.gameplay

import game.socket.RotmgMessageIds
import game.socket.fanchant.RotmgFanchant
import game.utils.autoToString
import java.io.DataInputStream

// represent when client hits an enemy
class EnemyHitFanchant : RotmgFanchant {
    override val type: String = RotmgMessageIds.ENEMYHIT.toString()

    var time: Int = 0
    var bulletId: Int = 0
    var targetId: Int = 0
    // no idea what is this
    // if client determining whether the enemy hit is dead or not
    // i think that doens't make sense in terms of cheating security
    var kill: Boolean = false

    override fun readBytes(bytes: DataInputStream) {
        time = bytes.readInt()
        bulletId = bytes.readByte().toInt()
        targetId = bytes.readInt()
        kill = bytes.readBoolean()
    }

    override fun toString(): String {
        return this.autoToString()
    }
}
