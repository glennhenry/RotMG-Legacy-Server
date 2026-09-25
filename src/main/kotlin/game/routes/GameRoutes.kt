package game.routes

import encore.fancam.Fancam
import encore.route.RouteHandler
import encore.route.guard.NoAuthGuard
import encore.route.handle
import game.routes.utils.formBodyToMap
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import java.io.File

class GameRoutes : RouteHandler {
    override fun Route.install() {
        post("/app/getLanguageStrings") {
            handle(call, NoAuthGuard) {
                val payload = call.receiveText().formBodyToMap()
                Fancam.debug { "Request to getLanguageStrings: $payload" }
                call.respondFile(File("assets/game/strings.json"))
            }
        }
        post("/app/init") {
            handle(call, NoAuthGuard) {
                val payload = call.receiveText().formBodyToMap()
                Fancam.debug { "Request to init: $payload" }
                call.respondFile(File("assets/game/init.json"))
            }
        }
    }
}
