package game.domain.world.movement

import game.domain.data.MoveRecord
import game.domain.data.WorldPosData
import game.socket.RotmgMessageIds
import game.socket.fanchant.RotmgFanchant
import game.utils.autoToString
import java.io.DataInputStream

class MoveFanchant : RotmgFanchant {
    override val type: String = RotmgMessageIds.MOVE.toString()

    var tickId: Int = 0
    var time: Int = 0
    var newPos: WorldPosData = WorldPosData(0, 0)
    val moveRecords: MutableList<MoveRecord> = mutableListOf()

    override fun readBytes(bytes: DataInputStream) {
        tickId = bytes.readInt()
        time = bytes.readInt()
        newPos = WorldPosData.readBytes(bytes)
        val moveLength = bytes.readShort().toInt()
        repeat(moveLength) {
            moveRecords.add(MoveRecord.readBytes(bytes))
        }
    }

    override fun toString(): String {
        return this.autoToString()
    }
}
