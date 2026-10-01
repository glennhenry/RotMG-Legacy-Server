package game.domain.data

import game.socket.outgoing.OutgoingMessage
import java.io.DataOutputStream

data class StatData(
    val statType: Int,
    val statValue: Int? = null,        // if statType is non string
    val strStatValue: String? = null   // if statType is string
) : OutgoingMessage {
    override fun write(output: DataOutputStream) {
        output.writeByte(statType) // ubyte
        if (statValue != null) {
            output.writeInt(statValue)
        }
        if (strStatValue != null) {
            output.writeUTF(strStatValue)
        }
        // todo add statType classification
    }
}
