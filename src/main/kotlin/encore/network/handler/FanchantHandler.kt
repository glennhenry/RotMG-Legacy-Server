package encore.network.handler

import encore.network.fanchant.Fanchant
import encore.network.transport.Connection
import kotlin.reflect.KClass

/**
 * Represent a handler for network messages.
 *
 * A [FanchantHandler] processes a specific kind of [Fanchant] produced
 * by the message decoding and materialization pipeline.
 *
 * Each handler is expected to declare the logical fanchant type
 * it handles via [fanchantType].
 *
 * Handler is dispatched by matching between [Fanchant.type] and the [fanchantType]
 * of handler. This mean that there should only be **one handler per one fanchant type**.
 *
 * For instance:
 * - A protocol may associate a `LoginFanchant` with the `"login"` type.
 *   A `LoginHandler` declaring `T = LoginFanchant` and
 *   `fanchantType = "login"` will only receive fanchants
 *   exclusively materialized into `LoginFanchant`.
 *
 * @param T The concrete implementation of [Fanchant] this handler expects.
 */
interface FanchantHandler<T : Fanchant> {
    /**
     * Describes the type of fanchant this handler is responsible to handle.
     *
     * This value is compared against [Fanchant.type] during dispatchment.
     * Handler should ensure that this identifier matches the concrete [T]
     * fanchant's type.
     *
     * **Important**: all fanchant type should be different, regardless
     * if they are a different [Fanchant] implementation. This is because
     * dispatchment logic primarily rely on type.
     *
     * A mismatch between this value and the actual runtime type of [T]
     * will not be caught at compile time and will result in a runtime
     * cast failure during dispatch.
     *
     * For example, if a handler declares `"login"` here but is parameterized
     * with `MoveMessage`, a received `"login"` payload will be cast to
     * `MoveMessage` at runtime and fail.
     */
    val fanchantType: String

    /**
     * This handler expected fanchant class.
     * This should be same as the [T] fanchant type.
     * Use `Fanchant::class`.
     */
    val expectedFanchantClass: KClass<T>

    /**
     * Handles an incoming [Fanchant] with the given handler [ctx].
     *
     * @param ctx Required information for message handling.
     *            This contains the materialized message and the player's [Connection] object.
     */
    suspend fun handle(ctx: HandlerContext<T>)
}
