package game.domain

import encore.fancam.Fancam
import encore.network.handler.FanchantHandler
import encore.network.handler.HandlerContext
import game.socket.fanchant.FallbackRotmgFanchant
import game.socket.fanchant.RotmgFanchant
import kotlin.reflect.KClass

/**
 * A fallback handler for [RotmgFanchant].
 * - [fanchantType] has a messageId or type of "fallback" which matches with
 *   [FallbackRotmgFanchant].
 * - [handle] logs the unhandle-ment.
 *
 * @constructor Creates a new RotmgFallbackHandler
 */
class RotmgFallbackHandler : FanchantHandler<FallbackRotmgFanchant> {
    override val fanchantType: String = "fallback"
    override val expectedFanchantClass: KClass<FallbackRotmgFanchant> = FallbackRotmgFanchant::class

    override suspend fun handle(ctx: HandlerContext<FallbackRotmgFanchant>) = with(ctx) {
        Fancam.warn { "Unhandled RotmgFanchant: $fanchant" }
    }
}
