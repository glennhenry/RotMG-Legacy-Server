package encore.network.handler

import encore.fancam.Fancam
import encore.fancam.Tags
import encore.network.fanchant.AllRounderFanchant

/**
 * Fallback-based handler implementation of [FanchantHandler].
 *
 * This is used to catch all unrecognized, unsupported, or unregistered
 * fanchant types. It ensures any kind of packets get received and logged.
 *
 * It can also be used as a place to quickly prototype a response without
 * actually implementing a strict fanchant guide or fanchant class.
 */
class AllRounderHandler : FanchantHandler<AllRounderFanchant> {
    override val fanchantType: String = "N/A"

    override suspend fun handle(ctx: HandlerContext<AllRounderFanchant>) = with(ctx) {
        Fancam.warn(Tags.Socket) { "Unhandled fanchant of type '${fanchant.type}'" }

        // directly respond here...
    }
}
