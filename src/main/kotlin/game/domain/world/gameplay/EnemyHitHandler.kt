package game.domain.world.gameplay

import encore.network.handler.FanchantHandler
import encore.network.handler.HandlerContext
import game.context.ServerContext
import game.domain.data.ObjectData
import game.domain.data.ObjectStatusData
import game.domain.data.StatData
import game.domain.data.StatDataConstants
import game.domain.world.UpdateMessage
import game.socket.RotmgMessageIds
import game.socket.outgoing.createMessage

class EnemyHitHandler(private val serverContext: ServerContext) : FanchantHandler<EnemyHitFanchant> {
    override val fanchantType: String = RotmgMessageIds.ENEMYHIT.toString()

    override suspend fun handle(ctx: HandlerContext<EnemyHitFanchant>) = with(ctx) {
        @Suppress("UNCHECKED_CAST")
        val pair = connection.get("mobs") as? Pair<*, *>
        val mobObjData = pair?.first as? ObjectData
        val mobHp = pair?.second as? Int

        if (mobObjData != null && mobHp != null) {
            val dmg =
                requireNotNull(connection.get("lastbullet") as? Int) { "lastbullet null, check PlayerShootHandler" }

            if ((mobHp - dmg) <= 0) {
                // mobs dead, send update
                val obj = listOf(
                    // this includes loot
                    // should randomize loot of course
                    ObjectData(
                        // white bag
                        objectType = 1292,
                        status = ObjectStatusData(
                            objectId = 6,
                            pos = mobObjData.status.pos,
                            stats = listOf(
                                // shield of ogmur
                                StatData(
                                    statType = StatDataConstants.INVENTORY_0_STAT,
                                    statValue = 3087
                                ),
                                StatData(
                                    statType = StatDataConstants.INVENTORY_1_STAT,
                                    statValue = 2591
                                ),
                                StatData(
                                    statType = StatDataConstants.SIZE_STAT,
                                    statValue = 50
                                ),
                            )
                        )
                    ),
                )

                val msg = UpdateMessage(
                    newTiles = emptyList(),
                    newObjects = obj,
                    // delete the king object
                    drops = listOf(3)
                )

                connection.write(createMessage(RotmgMessageIds.UPDATE, msg))
                connection.delete("mobs")
                val actId = connection.get("mobsattack") as String
                serverContext.stageActDirector.stop(actId)
                connection.delete("mobsattack")
            } else {
                connection.put("mobs", mobObjData to mobHp - dmg)
            }
        }
    }
}
