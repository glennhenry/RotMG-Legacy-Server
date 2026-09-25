package encore.network.handler

import game.mongo.collection.PlayerId
import encore.network.fanchant.Fanchant
import encore.network.transport.Connection

/**
 * Encapsulate objects and data needed by handlers to handle network messages.
 *
 * @property connection The [Connection] object of the player.
 * @property fanchant The received network message to be handled.
 * @param T Concrete type of the message.
 */
data class HandlerContext<out T : Fanchant>(
    val connection: Connection,
    val fanchant: T
)

fun HandlerContext<*>.playerId(): PlayerId {
    return connection.playerId
}
