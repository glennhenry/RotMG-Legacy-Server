package encore.backstage

import encore.fancam.Fancam
import encore.fancam.Tags
import encore.route.RouteHandler
import encore.route.guard.NoAuthGuard
import encore.route.handle
import encore.time.TimeCenter
import encore.utils.identifier.Ids
import encore.websocket.WebSocketMessage
import game.context.ServerContext
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import io.ktor.server.websocket.*
import io.ktor.utils.io.*
import io.ktor.websocket.*
import kotlinx.serialization.json.Json
import java.io.File
import kotlin.time.Duration.Companion.hours
import kotlin.time.Duration.Companion.minutes

/**
 * Backstage routes (devtools). In the backstage, there are three sections of tools:
 *  - **Console**: live log from server.
 *  - **Monitor**: server status and activity from server (e.g., active players, server state, running task).
 *  - **Command**: external input to control server runtime.
 *
 * Authentication/usage flow:
 * 1. User go to `/backstage`.
 * 2. Server respond with `wall.html`, asking for token.
 * 3. User type `token` in terminal to obtain an ephemeral token (1 minute).
 * 4. Server validates the token from user (via query parameters).
 *     - If invalid, send back `wall.html` (back to step 2).
 *     - If valid, set cookie of `backstage-clientId` with a new generated token (valid for 6 hours).
 *     Then, server responds with `backstage.html`.
 * 5. Client-side connects to websocket, including the previous token to the query parameter of the WS link.
 * 6. Server verify the WS query param.
 *     - If invalid, refuse the connection. This will prevent arbitrary websocket connection.
 *     The page will still be valid, though client can't do anything.
 *     - If valid, then websocket connection is approved.
 *     - From now on, refreshing page does not prompt `wall.html` anymore since server
 *     will also check this cookie.
 * 7. Client and server starts exchanging WS messages for console and commands tool.
 *     - Server sends log message on server to client for console.
 *     - Client periodically make API request to `/server-status`, including the cookie token
 *     to get monitoring status.
 *         - If cookie token is invalid, server return error status.
 *         - If cookie token is valid, server return JSON for server status.
 *     - Client can type command and it will be executed in the server.
 * 8. When session exceeded 6 hours, user needs to refresh. (step 6A).
 */
class BackstageRoutes(
    private val serverContext: ServerContext,
    private val tokenStorage: MutableMap<String, Long>
) : RouteHandler {
    override fun Route.install() {
        get("/backstage") {
            handle(call, NoAuthGuard) {
                val wallHtml = File("backstage/wall.html")
                val mainHtml = File("backstage/main.html")

                // skip auth on developmentMode
                if (application.developmentMode) {
                    Fancam.trace(Tags.Backstage) { "Auth skipped on /backstage (development mode)" }
                    call.respondFile(mainHtml)
                    return@handle
                }

                val token = call.request.queryParameters["token"]
                val cookie = call.request.cookies["backstage-clientId"]

                // PASS: user with cookie has already authenticated before
                if (cookie != null && serverContext.subunits.session.verify(cookie)) {
                    Fancam.trace(Tags.Backstage) { "Passed to /backstage: cookie available" }
                    call.respondFile(mainHtml)
                    return@handle
                }

                // WALL: user with cookie but expired
                if (cookie != null && !serverContext.subunits.session.verify(cookie)) {
                    Fancam.trace(Tags.Backstage) { "Wall to /backstage: cookie has expired" }
                    call.respondText(
                        insertHtmlTemplate(wallHtml, "{{MESSAGE}}", "Cookie expired"),
                        ContentType.Text.Html
                    )
                    return@handle
                }

                // WALL: user without cookie and without token.
                if (token == null) {
                    Fancam.trace(Tags.Backstage) { "Wall to /backstage: no token provided" }
                    call.respondText(insertHtmlTemplate(wallHtml, "{{MESSAGE}}", "Insert token"), ContentType.Text.Html)
                    return@handle
                }

                // WALL: user has unknown token
                if (!tokenStorage.contains(token)) {
                    Fancam.trace(Tags.Backstage) { "Wall to /backstage: got unknown token: $token" }
                    call.respondText(
                        insertHtmlTemplate(wallHtml, "{{MESSAGE}}", "Unknown token"),
                        ContentType.Text.Html
                    )
                    return@handle
                }

                // WALL: user has known token, but expired
                if (tokenStorage.contains(token) && TimeCenter.hasElapsedBy(tokenStorage[token]!!, 1.minutes)) {
                    Fancam.trace(Tags.Backstage) { "Wall to /backstage: token already expired" }
                    call.respondText(
                        insertHtmlTemplate(wallHtml, "{{MESSAGE}}", "Token expired"),
                        ContentType.Text.Html
                    )
                    return@handle
                }

                // PASS: user has valid token
                val session = serverContext.subunits.session.create(
                    userId = Ids.uuid(), validFor = 6.hours, lifetime = 6.hours
                )
                call.response.cookies.append("backstage-clientId", session.token, maxAge = 21600, path = "/backstage")
                Fancam.trace(Tags.Backstage) { "Passed to /backstage: token is valid" }
                call.respondFile(mainHtml)
            }
        }

        get("/backstage/server-status") {
            handle(call, NoAuthGuard) {
                if (!call.ensureSession { serverContext.subunits.session.verify(it) }) return@handle

                call.respond("Status received (work in progress).")
            }
        }

        get("/backstage/cmd-help-text") {
            handle(call, NoAuthGuard) {
                if (!call.ensureSession { serverContext.subunits.session.verify(it) }) return@handle

                val commands = serverContext.commandDispatcher.getAllRegisteredCommands()
                val html = StringBuilder()

                html.append("<ul>")
                for (cmd in commands) {
                    html.append("<li><b><code>${cmd.commandId}</code></b>: ${cmd.description}</li>")
                }
                html.append("</ul>")

                call.respondText(html.toString(), ContentType.Text.Html)
            }
        }

        webSocket("/backstage/ws") {
            val token = if (application.developmentMode) {
                // dev mode uses arbitrary identifier
                "DEV-${TimeCenter.now()}"
            } else {
                // websocket can't send cookie, token cookie for WS is included in the param instead
                // also verify the token
                call.request.queryParameters["token"]
                    ?.takeIf { serverContext.subunits.session.verify(it) }
            }

            if (token == null) {
                Fancam.trace(Tags.Backstage) { "Can't connect to /backstage WebSocket with invalid token=$token" }
                close(CloseReason(CloseReason.Codes.VIOLATED_POLICY, "Invalid token"))
                return@webSocket
            }
            Fancam.trace(Tags.Backstage) { "Connected to /backstage WebSocket" }

            serverContext.webSocketManager.addClient(token, this)

            try {
                for (frame in incoming) {
                    if (frame is Frame.Text) {
                        val msg = frame.readText()
                        try {
                            val wsMessage = Json.decodeFromString<WebSocketMessage>(msg)
                            if (wsMessage.type == "close") {
                                serverContext.webSocketManager.removeClient(token)
                                break
                            }
                            serverContext.webSocketManager.handleMessage(this, wsMessage)
                        } catch (e: Exception) {
                            Fancam.error(e, Tags.Backstage) { "Failed to parse WS message: $msg" }
                        }
                    }
                }
            } catch (_: CancellationException) {
            } catch (e: Exception) {
                Fancam.error(e, Tags.Backstage) { "Scandal on /backstage WebSocket for clientId=$token" }
            } finally {
                serverContext.webSocketManager.removeClient(token)
                Fancam.trace(Tags.Backstage) { "Client $token is disconnected from websocket" }
            }
        }
    }
}

/**
 * Simple helper for HTML templating.
 *
 * This will replace every occurence of `templateId` with [message] in the [file].
 */
fun insertHtmlTemplate(file: File, templateId: String, message: String): String {
    return file.readText().replace(templateId, message)
}

/**
 * Ensure backstage session is valid.
 *
 * Request must contain a non-expired cookie of `backstage-clientId`.
 *
 * @param verify Function used to verify the validity of the cookie.
 * @return Returns `true` when session is valid, `false` otherwise.
 */
suspend fun ApplicationCall.ensureSession(verify: (String) -> Boolean): Boolean {
    val cookie = request.cookies["backstage-clientId"]
    val cookieValid = cookie != null && verify(cookie)

    if (!application.developmentMode && !cookieValid) {
        respond(HttpStatusCode.Forbidden, "Session invalid, please re-login")
        return false
    }

    return true
}
