package game.routes

import encore.route.RouteHandler
import encore.route.guard.NoAuthGuard
import encore.route.handle
import io.ktor.server.response.*
import io.ktor.server.routing.*
import java.io.File

class GameRoutes : RouteHandler {
    override fun Route.install() {
        post("/app/getLanguageStrings") {
            handle(call, NoAuthGuard) {
                call.respondFile(File("assets/game/strings.json"))
            }
        }
    }
}
