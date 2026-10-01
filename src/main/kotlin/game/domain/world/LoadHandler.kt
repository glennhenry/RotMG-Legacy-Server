package game.domain.world

import encore.network.handler.FanchantHandler
import encore.network.handler.HandlerContext
import game.domain.data.ObjectData
import game.domain.data.ObjectStatusData
import game.domain.data.TileData
import game.domain.data.WorldPosData
import game.socket.RotmgMessageIds
import game.socket.outgoing.createMessage

class LoadHandler : FanchantHandler<LoadFanchant> {
    override val fanchantType: String = RotmgMessageIds.LOAD.toString()

    override suspend fun handle(ctx: HandlerContext<LoadFanchant>) = with(ctx) {
        // example of vault portal object (1824) at x=55 y=55
        val obj = ObjectData(
            objectType = 1824,
            status = ObjectStatusData(
                objectId = 1,
                pos = WorldPosData(55, 55),
                stats = emptyList()
            )
        )

        val msg = UpdateMessage(
            newTiles = mockTiles(100, 100),
            newObjects = listOf(obj),
            drops = emptyList()
        )

        connection.write(createMessage(RotmgMessageIds.UPDATE, msg))
    }

    fun mockTiles(width: Int, height: Int): List<TileData> {
        val result = mutableListOf<TileData>()
        for (x in 0..width) {
            for (y in 0..height) {
                // type 28 is dirt tile
                result.add(TileData(x, y, 28))
            }
        }
        return result
    }
}
