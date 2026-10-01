package game.domain.world

import game.domain.data.ObjectData
import game.domain.data.TileData
import game.socket.outgoing.OutgoingMessage
import java.io.DataOutputStream

/**
 * An update represent the world update around player character.
 *
 * Gameplay explanation:
 * - When you move, you will see a new tile or object.
 * - You may also see a loot bag if there is any.
 * - This also includes if enemy dead, an update is sent.
 *   Maybe no new tiles or objects, but there is a loot bag drop.
 */
class UpdateMessage(
    val newTiles: List<TileData>,
    val newObjects: List<ObjectData>,
    val drops: List<Int> // if this is loot bag, no idea why is it integer
) : OutgoingMessage {
    override fun write(output: DataOutputStream) {
        output.writeShort(newTiles.size)
        newTiles.forEach { it.write(output) }
        output.writeShort(newObjects.size)
        newObjects.forEach { it.write(output) }
        output.writeShort(drops.size)
        drops.forEach { output.writeInt(it) }
    }
}
