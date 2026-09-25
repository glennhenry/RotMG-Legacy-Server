package encoreTest.network.server

import encore.network.fanchant.Fanchant
import encore.network.fanchant.FanchantCoordinator
import encore.network.handler.FanchantHandler
import encore.network.handler.HandlerContext
import encore.utils.support.className
import kotlin.reflect.KClass
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertFailsWith

class FanchantCoordinatorTest {
    @Test
    fun `dispatch success with one fanchant type and one handler`() {
        val dispatcher = FanchantCoordinator()
        val handler1 = Handler1()
        dispatcher.register(handler1)

        val actual = dispatcher.findHandler(ExFc("asdf"))
        assertEquals(handler1.className(), actual.className())
    }

    @Test
    fun `register fails when the same type was already associated`() {
        val dispatcher = FanchantCoordinator()
        dispatcher.register(Handler1())
        assertFailsWith<IllegalArgumentException> {
            dispatcher.register(Handler2())
        }
    }
}

class Handler1 : FanchantHandler<ExFc> {
    override val fanchantType: String = "type1"
    override val expectedFanchantClass: KClass<ExFc> = ExFc::class
    override suspend fun handle(ctx: HandlerContext<ExFc>) {
        println("Handler1 - handle")
    }
}

class Handler2 : FanchantHandler<ExFc> {
    override val fanchantType: String = "type1"
    override val expectedFanchantClass: KClass<ExFc> = ExFc::class
    override suspend fun handle(ctx: HandlerContext<ExFc>) {
        println("Handler2 - handle")
    }
}

class ExFc(val payload: String) : Fanchant {
    override val type: String = "type1"
    override fun toString(): String = "ExMsg1($payload)"
}
