package game.routes

import encore.fancam.Fancam
import encore.route.RouteHandler
import io.ktor.http.HttpStatusCode
import io.ktor.server.http.content.staticFiles
import io.ktor.server.response.respond
import io.ktor.server.response.respondFile
import io.ktor.server.routing.Route
import io.ktor.server.routing.get
import java.io.File

/**
 * Serve file-related endpoints.
 *
 * This mostly serving static files:
 * - Game and website assets in the `assets` folder.
 * - Docs website on production in the `docs_build` folder.
 *
 * Since this is simple, it doesn't use the [RouteHandler]
 */
fun Route.fileRoutes() {
    get("/") {
        call.respondFile(File("assets/site/index.html"))
    }
    staticFiles("site", File("assets/site"))
    staticFiles("game", File("assets/game"))
    get("/crossdomain.xml") {
        call.respondFile(File("assets/crossdomain.xml"))
    }
    get("/sfx/{filename}") {
        val filename = requireNotNull(call.pathParameters["filename"]) { "No file name GET sfx/" }
        val file = File("assets/game/sfx/$filename")
        if (file.exists()) {
            call.respondFile(file)
        } else {
            Fancam.warn { "Missing file: ${file.path}" }
        }
    }
    get("/sfx/player/{filename}") {
        val filename = requireNotNull(call.pathParameters["filename"]) { "No file name GET sfx/player/" }
        val file = File("assets/game/sfx/player/$filename")
        if (file.exists()) {
            call.respondFile(file)
        } else {
            Fancam.warn { "Missing file: ${file.path}" }
        }
    }
    get("/sfx/monster/{filename}") {
        val filename = requireNotNull(call.pathParameters["filename"]) { "No file name GET sfx/monster/" }
        val file = File("assets/game/sfx/monster/$filename")
        if (file.exists()) {
            call.respondFile(file)
        } else {
            Fancam.warn { "Missing file: ${file.path}" }
        }
    }
    get("/music/{filename}") {
        val filename = requireNotNull(call.pathParameters["filename"]) { "No file name GET music/" }
        call.respondFile(File("assets/game/music/$filename"))
    }

    val docsDir = File("docs_build")
    if (File(docsDir, "index.html").exists()) {
        staticFiles("docs", docsDir)
    } else {
        get("/docs") {
            call.respond(
                HttpStatusCode.NotFound,
                "Docs website not available. Please start it with a separate vite server. " +
                        "If in prod, build the documentation website to access it."
            )
        }
    }
}
