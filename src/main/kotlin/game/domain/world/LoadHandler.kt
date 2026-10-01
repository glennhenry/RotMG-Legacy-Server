package game.domain.world

import encore.network.handler.FanchantHandler
import encore.network.handler.HandlerContext
import game.domain.data.ObjectData
import game.domain.data.ObjectStatusData
import game.domain.data.StatData
import game.domain.data.StatDataConstants
import game.domain.data.TileData
import game.domain.data.WorldPosData
import game.socket.RotmgMessageIds
import game.socket.outgoing.createMessage

class LoadHandler : FanchantHandler<LoadFanchant> {
    override val fanchantType: String = RotmgMessageIds.LOAD.toString()

    override suspend fun handle(ctx: HandlerContext<LoadFanchant>) = with(ctx) {
        // example of vault portal object (1824) at x=55 y=55
        // a player object
        // and enemy mobs
        val obj = listOf(
            ObjectData(
                objectType = 1824,
                status = ObjectStatusData(
                    objectId = 2,
                    pos = WorldPosData(1, 1),
                    stats = emptyList()
                )
            ),
            createPlayerObject(),
            // shtrs Forgotten King
            ObjectData(
                objectType = 29039,
                status = ObjectStatusData(
                    objectId = 3,
                    pos = WorldPosData(7, 8),
                    stats = listOf(
                        StatData(
                            statType = StatDataConstants.SIZE_STAT,
                            statValue = 200
                        ),
                    )
                )
            ),
        )

        val msg = UpdateMessage(
            newTiles = mockTiles(10, 10),
            newObjects = obj,
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

    fun createPlayerObject(): ObjectData {
        // wizard (782) with t4 staff and t5 spell; slime skin wizard (872)
        // for inventory: <= 0 = empty; if its object type in xml = occupied
        // stat 0-3 is weapon,ability,armor,ring
        // stat 4-11 is inventory slot 1-8
        return ObjectData(
            objectType = 782,
            status = ObjectStatusData(
                objectId = 1,
                pos = WorldPosData(2, 2),
                stats = listOf(
                    StatData(
                        statType = StatDataConstants.LEVEL_STAT,
                        statValue = 20
                    ),
                    StatData(
                        statType = StatDataConstants.SIZE_STAT,
                        statValue = 120
                    ),
                    StatData(
                        statType = StatDataConstants.NUM_STARS_STAT,
                        statValue = 2
                    ),
                    StatData(
                        statType = StatDataConstants.FAME_STAT,
                        statValue = 2244
                    ),
                    StatData(
                        statType = StatDataConstants.CURR_FAME_STAT,
                        statValue = 2245
                    ),
                    StatData(
                        statType = StatDataConstants.MAX_HP_STAT,
                        statValue = 800
                    ),
                    StatData(
                        statType = StatDataConstants.HP_STAT,
                        statValue = 800
                    ),
                    StatData(
                        statType = StatDataConstants.MP_STAT,
                        statValue = 400
                    ),
                    StatData(
                        statType = StatDataConstants.MAX_MP_STAT,
                        statValue = 400
                    ),
                    StatData(
                        statType = StatDataConstants.ATTACK_STAT,
                        statValue = 70
                    ),
                    StatData(
                        statType = StatDataConstants.DEFENSE_STAT,
                        statValue = 40
                    ),
                    StatData(
                        statType = StatDataConstants.SPEED_STAT,
                        statValue = 70
                    ),
                    StatData(
                        statType = StatDataConstants.DEXTERITY_STAT,
                        statValue = 90
                    ),
                    StatData(
                        statType = StatDataConstants.VITALITY_STAT,
                        statValue = 50
                    ),
                    StatData(
                        statType = StatDataConstants.VITALITY_BOOST_STAT,
                        statValue = 10
                    ),
                    StatData(
                        statType = StatDataConstants.WISDOM_STAT,
                        statValue = 70
                    ),
                    StatData(
                        statType = StatDataConstants.HEALTH_POTION_STACK_STAT,
                        statValue = 20
                    ),
                    StatData(
                        statType = StatDataConstants.MAGIC_POTION_STACK_STAT,
                        statValue = 21
                    ),
                    StatData(
                        statType = StatDataConstants.INVENTORY_0_STAT,
                        statValue = 2715
                    ),
                    StatData(
                        statType = StatDataConstants.INVENTORY_1_STAT,
                        statValue = 2608
                    ),
                    // player skin
                    StatData(
                        statType = StatDataConstants.TEXTURE_STAT,
                        statValue = 872
                    ),
                    // cloth
                    StatData(
                        statType = StatDataConstants.TEX1_STAT,
                        statValue = 4157
                    ),
                    // accesory
                    StatData(
                        statType = StatDataConstants.TEX2_STAT,
                        statValue = 4413
                    ),
                )
            )
        )
    }
}
