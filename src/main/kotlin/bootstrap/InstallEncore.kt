package bootstrap

import com.mongodb.ConnectionString
import com.mongodb.MongoClientSettings
import com.mongodb.kotlin.client.coroutine.MongoClient
import com.mongodb.kotlin.client.coroutine.MongoDatabase
import encore.fancam.Fancam
import encore.fancam.Tags
import encore.fancam.formatter.colorizeSegmentFg
import encore.fancam.impl.OfficialFancam
import encore.route.colorizeHttpMethod
import encore.route.guard.GuardResult
import encore.route.guard.SecurityGuard
import encore.route.interceptResponse
import encore.route.stringifyHttpRequest
import encore.serialization.JSON
import encore.serialization.Protobuf
import encore.utils.support.className
import encore.venue.Venue
import io.ktor.http.*
import io.ktor.serialization.kotlinx.json.*
import io.ktor.serialization.kotlinx.protobuf.*
import io.ktor.server.application.*
import io.ktor.server.plugins.*
import io.ktor.server.plugins.contentnegotiation.*
import io.ktor.server.plugins.cors.routing.*
import io.ktor.server.plugins.doublereceive.*
import io.ktor.server.plugins.statuspages.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.websocket.*
import kotlinx.serialization.ExperimentalSerializationApi
import kotlinx.serialization.json.Json
import kotlinx.serialization.modules.SerializersModule
import kotlinx.serialization.protobuf.ProtoBuf
import org.bson.Document
import org.bson.codecs.configuration.CodecRegistries.fromProviders
import org.bson.codecs.configuration.CodecRegistries.fromRegistries
import org.bson.codecs.configuration.CodecRegistry
import org.bson.codecs.kotlinx.KotlinSerializerCodecProvider
import kotlin.time.Duration.Companion.seconds

/**
 * Includes configuration for the framework.
 *
 * This contains a general, rarely changing setting for various components
 * including Ktor or the Encore framework itself.
 *
 * 1. Serialization utilities: [JSON], [Protobuf].
 * 2. Logging capabilities via [Fancam].
 * 3. Configure CORS.
 * 4. Status pages for unhandled pages or internal server errors.
 * 5. Configure WebSocket.
 * 6. Configure security.
 * 7. Install HTTP response interception.
 * 8. Initialize the Mongo database.
 *
 * @param module Configure advanced serialization settings, such as polymorphism,
 *               custom serializer, or sealed hierarchies. This is used for [Json]
 *               and [ProtoBuf] configuration.
 * @param security Configure API security with [SecurityGuard].
 * @return [MongoDatabase] for application usage.
 */
suspend fun Application.installEncore(
    module: SerializersModule = SerializersModule { },
    security: SecurityGuard
): MongoDatabase {
    configureSerialization(module)
    configureFancam()
    configureCors()
    configureStatusPages()
    configureDoubleReceive()
    configureWebSocket()
    configureSecurity(security)
    interceptResponse()
    return configureDatabase()
}

@OptIn(ExperimentalSerializationApi::class)
fun Application.configureSerialization(module: SerializersModule = SerializersModule { }) {
    val json = Json {
        serializersModule = module
        classDiscriminator = "_t"
        prettyPrint = true
        isLenient = true
        ignoreUnknownKeys = true
        encodeDefaults = true
    }
    val protobuf = ProtoBuf {
        serializersModule = module
        encodeDefaults = true
    }

    install(ContentNegotiation) {
        json(json)
        protobuf(protobuf)
    }
    JSON.initialize(json)
    Protobuf.initialize(protobuf)
}

fun configureFancam() {
    Fancam.initialize(OfficialFancam(Venue.encore.fancam))
    if (Venue.encore.devMode) {
        Fancam.info(Tags.Startup) { "Running server on developmentMode" }
    } else {
        Fancam.info(Tags.Startup) { "developmentMode is off" }
    }
}

fun Application.configureCors() {
    install(CORS) {
        anyHost() // change this on production
        allowHeaders { true }
        allowMethod(HttpMethod.Get)
        allowMethod(HttpMethod.Post)
        allowMethod(HttpMethod.Put)
        allowMethod(HttpMethod.Delete)
        allowMethod(HttpMethod.Options)
    }
}

fun Application.configureStatusPages() {
    install(StatusPages) {
        exception<Throwable> { call, cause ->
            val method = colorizeHttpMethod(call.request.httpMethod.value)
            val uri = call.request.uri

            Fancam.error(cause, Tags.Api) { "Internal server scandal on $method $uri" }

            val message = if (Venue.encore.devMode) {
                cause.stackTrace.joinToString("\n")
            } else {
                "Stage was sabotaged... T_T"
            }

            call.respondText(
                text = errorHtml(500, "<pre>${message}</pre>"),
                contentType = ContentType.Text.Html,
                status = HttpStatusCode.InternalServerError
            )
        }

        unhandled { call ->
            val req = call.stringifyHttpRequest(unhandled = true)
            Fancam.warn(Tags.Api) { req }

            call.respondText(
                text = errorHtml(404, "Not found in the system."),
                contentType = ContentType.Text.Html,
                status = HttpStatusCode.NotFound
            )
        }
    }
}

fun Application.configureDoubleReceive() {
    install(DoubleReceive)
}

/**
 * Simple HTML template of an error page.
 *
 * @param code HTTP response status code.
 * @param message Context message to display.
 */
fun errorHtml(code: Int, message: String): String {
    return "<!doctypehtml>" +
            "<html lang=en>" +
            "<meta charset=UTF-8>" +
            "<title>Uh-oh... contract ended</title>" +
            "<style>" +
            "body{font-family:system-ui,-apple-system,sans-serif;background-color:#f5f5f5}" +
            "h1{font-size:1.2rem}</style>" +
            "<div class=container>" +
            "<h1>Error: $code</h1>" +
            "<p>$message" +
            "</div>"
}

val CodecRegistry: CodecRegistry = fromRegistries(
    MongoClientSettings.getDefaultCodecRegistry(),
    fromProviders(
        KotlinSerializerCodecProvider()
    )
)

suspend fun configureDatabase(): MongoDatabase {
    val mongoc = MongoClient.create(
        MongoClientSettings.builder()
            .applyConnectionString(ConnectionString(Venue.encore.database.dbUrl))
            .codecRegistry(CodecRegistry)
            .build()
    )
    val testDb = mongoc.getDatabase("admin")
    val commandResult = testDb.runCommand(Document("ping", 1))
    Fancam.info(Tags.Startup) { "MongoDB connection successful: $commandResult" }
    val db = mongoc.getDatabase(Venue.encore.database.dbName)
        .withCodecRegistry(CodecRegistry)
    return db
}

fun Application.configureWebSocket() {
    install(WebSockets) {
        pingPeriod = 15.seconds
        timeout = 15.seconds
        masking = true
    }
}

/**
 * Configure global API routes security.
 */
fun Application.configureSecurity(security: SecurityGuard) {
    intercept(ApplicationCallPipeline.Plugins) {
        when (val result = security.verify(call)) {
            is GuardResult.Welcome -> proceed()
            is GuardResult.GetOut -> {
                val req = call.stringifyHttpRequest(unhandled = false)
                Fancam.debug(Tags.Api) { req }

                call.respondText(
                    text = errorHtml(result.status.value, result.message),
                    contentType = ContentType.Text.Html,
                    status = result.status
                )

                val remote = call.request.origin.remoteHost
                Fancam.trace(Tags.Api) {
                    "'${call.request.uri}' -> ${
                        colorizeSegmentFg(
                            161,
                            "SecurityGuard.GetOut"
                        )
                    } by ${security.className()} for $remote with reason: ${result.reason ?: "<unspecified>"}"
                }
                finish()
            }

            is GuardResult.Reject -> {
                val req = call.stringifyHttpRequest(unhandled = false)
                Fancam.debug(Tags.Api) { req }

                val remote = call.request.origin.remoteHost
                Fancam.trace(Tags.Api) {
                    "'${call.request.uri}' -> ${
                        colorizeSegmentFg(
                            161,
                            "SecurityGuard.Reject"
                        )
                    } by ${security.className()} for $remote with reason: ${result.reason ?: "<unspecified>"}"
                }
                finish()
            }
        }
    }
}
