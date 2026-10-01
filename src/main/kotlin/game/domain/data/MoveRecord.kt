package game.domain.data

import java.io.DataInputStream

data class MoveRecord(val x: Int, val y: Int, val time: Int) {
    companion object {
        fun readBytes(bytes: DataInputStream): MoveRecord {
            return MoveRecord(
                time = bytes.readInt(),
                x = bytes.readFloat().toInt(),
                y = bytes.readFloat().toInt()
            )
        }
    }
}
