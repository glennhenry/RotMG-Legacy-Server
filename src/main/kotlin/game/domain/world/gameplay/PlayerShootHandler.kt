package game.domain.world.gameplay

import encore.network.handler.FanchantHandler
import encore.network.handler.HandlerContext
import game.socket.RotmgMessageIds
import game.socket.outgoing.createMessage
import kotlin.random.Random

/**
 * Handles when the player shoot.
 * This includes hitting or not hitting anything.
 * The damage will be calculated still.
 *
 * The handler is supposed to verify shoot and give damage.
 * Cheater client may send arbitrary bullet, so server should invalidate that.
 */
class PlayerShootHandler : FanchantHandler<PlayerShootFanchant> {
    override val fanchantType: String = RotmgMessageIds.PLAYERSHOOT.toString()

    override suspend fun handle(ctx: HandlerContext<PlayerShootFanchant>) = with(ctx) {
        val dmg = Random.nextInt(20, 40)
        val msg = ServerPlayerShootMessage(
            bulletId = fanchant.bulletId,
            ownerId = 1,
            containerType = fanchant.containerType,
            startPos = fanchant.startPos,
            angle = fanchant.angle,
            // this represents the damage that the player's weapon produces
            // this should be calculated based on weapon's damage and atk stat
            // defense is calculated by client itself
            // proof: dmg may be 20-40, but client display as lower value because of high def
            damage = dmg
            // the damage sent to client should not consider defense
            // but for server-side damage tracking, it should consider defense
            // without considering defense on server,
            // the client would deal low damage but kill as fast as the server tracks (which is unexpected for player)
        )

        // put reference to last bullet dmg
        // there should be much more advanced table tracking
        connection.put("lastbulletdmg", dmg)

        connection.write(createMessage(RotmgMessageIds.SERVERPLAYERSHOOT, msg))
    }
}
