package game.domain.world.status

import game.domain.data.ObjectData
import game.domain.data.TileData
import game.socket.outgoing.OutgoingMessage
import java.io.DataOutputStream

/**
 * An update represent the world render update around player character.
 *
 * Gameplay explanation:
 * - On first time player entered, an `Update` should provide every tiles and objects.
 * - When a tile changes (e.g., like Sentinel's bridge), the `newTiles` should be utilized.
 * - When an object is added (e.g., enemy spawn, player spawn), the `newObjects` should be utilized.
 * - When an object is deleted (e.g., enemy dead, loot bag taken), the `drops` should list the `objectId` to be removed.
 *
 * This probably does not include new tiles when player walks into new area.
 * It's because the client don't send update of position and it would be too resource consuming to do that.
 * Unless if it's breaking walls in snake pit, it may be possible for tiles to be
 * lazily loaded after wall is broken (although complex, it's possible because of player shoot handler).
 */
class UpdateMessage(
    val newTiles: List<TileData>,
    val newObjects: List<ObjectData>,
    val drops: List<Int> // drops represent the list of objects to be removed in the next render
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
