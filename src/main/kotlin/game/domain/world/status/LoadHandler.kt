package game.domain.world.status

import encore.acts.ActScope
import encore.acts.template.ForeverTimerAct
import encore.acts.template.ForeverTimerConcept
import encore.network.handler.FanchantHandler
import encore.network.handler.HandlerContext
import game.context.ServerContext
import game.domain.data.*
import game.domain.world.gameplay.EnemyShootMessage
import game.socket.RotmgMessageIds
import game.socket.outgoing.createMessage
import kotlin.random.Random
import kotlin.time.Duration.Companion.seconds

class LoadHandler(private val serverContext: ServerContext) : FanchantHandler<LoadFanchant> {
    override val fanchantType: String = RotmgMessageIds.LOAD.toString()

    override suspend fun handle(ctx: HandlerContext<LoadFanchant>) = with(ctx) {
        val mobs = ObjectData(
            // shtrs Forgotten King
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
        )
        // temporarily store object data in player's connection
        // should make some subunit of world objects table
        // 400 is an example of mobs hp
        connection.put("mobs", mobs to 400)

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
            mobs
        )

        val msg = UpdateMessage(
            newTiles = mockTiles(10, 10),
            newObjects = obj,
            drops = emptyList()
        )

        connection.write(createMessage(RotmgMessageIds.UPDATE, msg))

        // update of mobs movement
        // advanced-ly, this may tracks player, chase, or go to set position
        // NOT WORKING YET...
        // the plan is: delete old object, create new object
        // but unsure if delete/recreate means reseting the mobs HP
//        if (connection.get("updatetimer") == null) {
//            serverContext.stageActDirector.run(
//                act = RepeatingTimerAct(),
//                concept = RepeatingTimerConcept(
//                    initialDelay = 2.seconds,
//                    repetition = 20,
//                    interval = 3.seconds
//                ) {
//                    val msg = createMessage(
//                        messageId = RotmgMessageIds.UPDATE,
//                        outgoing = UpdateMessage(
//                            newTiles = emptyList(),
//                            newObjects = listOf(
//                                ObjectData(
//                                    objectType = 29039,
//                                    status = ObjectStatusData(
//                                        objectId = prevObjId + 1,
//                                        pos = WorldPosData(
//                                            x = Random.nextInt(4, 8),
//                                            y = Random.nextInt(4, 8)
//                                        ),
//                                        stats = listOf(
//                                            StatData(
//                                                statType = StatDataConstants.SIZE_STAT,
//                                                statValue = 200
//                                            ),
//                                        )
//                                    )
//                                ).also { mobs = it }
//                            ),
//                            drops = listOf(prevObjId - 1)
//                        )
//                    )
//                    connection.write(msg)
//                },
//                scope = ActScope(connection.address, connection.connectionScope)
//            )
//            connection.put("updatetimer", true)
//            prevObjId += 1
//        }

        // enemy shoot repeatedly after 3 seconds every 2 seconds until it dies
        val actId = serverContext.stageActDirector.run(
            act = ForeverTimerAct(),
            concept = ForeverTimerConcept(
                initialDelay = 3.seconds,
                interval = 1.seconds
            ) {
                val msg = createMessage(
                    messageId = RotmgMessageIds.ENEMYSHOOT,
                    // this works by:
                    // refer to a particular enemy
                    // refer the projectile index
                    // this limit something: arbitrary mobs can't shoot arbitrary projectile
                    // e.g., Oryx 2 can't shoot King's fire tentacles
                    outgoing = EnemyShootMessage(
                        // unique identifier of bullet
                        bulletId = 11,
                        // this is used to refer to the Objects.xml shtrs Forgotten King
                        ownerId = mobs.status.objectId,
                        // use the index 2 bullet which is Fire Bullet
                        bulletType = 2,
                        startPos = mobs.status.pos,
                        angle = Random.nextDouble(0.2, 0.5).toFloat(),
                        // the Objects.xml alreeady list dmg, but it can be modified
                        damage = 120,
                        numShots = 8,
                        angleInc = Random.nextDouble(0.1, 0.2).toFloat()
                    )
                )
                connection.write(msg)
            },
            scope = ActScope(connection.address, connection.connectionScope)
        )

        // after mobs died, this repeating task should be stopped
        connection.put("mobsattack", actId)
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
