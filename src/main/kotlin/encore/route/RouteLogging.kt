package encore.route

import encore.fancam.Fancam
import encore.fancam.INDENT
import encore.fancam.Tags
import encore.fancam.formatter.colorizeSegmentFg
import encore.time.TimeCenter
import io.ktor.http.HttpStatusCode
import io.ktor.server.application.Application
import io.ktor.server.application.ApplicationCall
import io.ktor.server.application.PipelineCall
import io.ktor.server.plugins.origin
import io.ktor.server.request.contentLength
import io.ktor.server.request.contentType
import io.ktor.server.request.httpMethod
import io.ktor.server.request.receiveText
import io.ktor.server.request.uri
import io.ktor.server.response.ApplicationSendPipeline
import io.ktor.util.AttributeKey

suspend fun ApplicationCall.stringifyHttpRequest(unhandled: Boolean): String {
    return buildString {
        if (unhandled) {
            appendLine("----- [Unhandled HTTP Request]")
        } else {
            appendLine("----- [HTTP Request]")
        }

        val method = colorizeHttpMethod(request.httpMethod.value)
        if (!hasBody()) {
            append("$INDENT $method ${request.uri}")
            return@buildString
        }

        appendLine("$INDENT $method ${request.uri}")

        val type = request.contentType()
        val length = request.contentLength() ?: "N/A"
        val host = request.origin.remoteHost.takeIf { it.isNotBlank() } ?: "N/A"

        appendLine("$INDENT type=$type, length=$length, remote=$host")

        val body = request.call.receiveText()

        appendLine("$INDENT <=========body=========>")
        appendLine("$INDENT $body")
        append("$INDENT <=========end==========>")
    }
}

fun Application.interceptResponse() {
    sendPipeline.intercept(ApplicationSendPipeline.After) {
        val call = context.request.call
        val startedAt = call.attributes.getOrNull(ReqResLoggingKey) ?: return@intercept
        val elapsed = TimeCenter.elapsedTimeSince(startedAt)

        Fancam.debug(Tags.Api) { call.stringifyHttpResponse(subject, elapsed) }
    }
}

fun PipelineCall.stringifyHttpResponse(subject: Any, elapsed: Long): String {
    return buildString {
        val status = colorizeStatusCode(response.status())
        val method = colorizeHttpMethod(request.httpMethod.value)

        appendLine("----- [HTTP Response]")
        appendLine("$INDENT $status $method ${request.uri} (${elapsed}ms)")
        append("$INDENT body: ${subject.toLogBody()}")
    }
}

val ReqResLoggingKey = AttributeKey<Long>("started-at")

fun ApplicationCall.hasBody(): Boolean {
    return request.httpMethod.value == "POST" || request.httpMethod.value == "PUT"
}

fun Any?.toLogBody(): String {
    return when (this) {
        null -> "null"
        is String -> {
            "text(length=$length)"
        }

        is ByteArray -> {
            "binary(length=$size)"
        }

        else -> {
            val type = this::class.simpleName ?: "unknown"
            "$type(${toString().length} chars)"
        }
    }
}

fun colorizeHttpMethod(method: String): String {
    return when (method.lowercase()) {
        "get" -> colorizeSegmentFg(28, method)
        "post" -> colorizeSegmentFg(68, method)
        "put" -> colorizeSegmentFg(140, method)
        "delete" -> colorizeSegmentFg(161, method)
        else -> colorizeSegmentFg(5, method)
    }
}

fun colorizeStatusCode(status: HttpStatusCode?): String {
    if (status == null) {
        return colorizeSegmentFg(249, "no-status")
    }

    return when (status.value) {
        in 100..199 -> {
            colorizeSegmentFg(249, status.toString())
        }

        in 200..299 -> {
            colorizeSegmentFg(28, status.toString())
        }

        in 300..399 -> {
            colorizeSegmentFg(110, status.toString())
        }

        in 400..499 -> {
            colorizeSegmentFg(124, status.toString())
        }

        in 500..599 -> {
            colorizeSegmentFg(124, status.toString())
        }

        else -> {
            colorizeSegmentFg(249, "no-status")
        }
    }
}
