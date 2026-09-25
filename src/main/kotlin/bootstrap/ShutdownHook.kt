package bootstrap

import game.context.ServerSubunits
import encore.fancam.Fancam
import encore.fancam.Tags
import encore.network.stage.Stage
import encore.subunit.scope.ServerScope
import encore.subunit.Subunit
import io.ktor.utils.io.CancellationException
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.cancel
import kotlinx.coroutines.job
import kotlinx.coroutines.runBlocking
import kotlin.collections.forEach

/**
 * Install a hook for the application shutdown which will:
 * - Disband every server [Subunit]
 * - Shutdown every [servers]
 * - Cancels the application coroutine [appScope]
 */
fun shutdownHook(
    appScope: CoroutineScope,
    serverSubunitScope: ServerScope,
    subunits: ServerSubunits,
    servers: List<Stage>
) {
    Runtime.getRuntime().addShutdownHook(Thread {
        runBlocking {
            try {
                subunits.disband(serverSubunitScope)
                servers.forEach { server ->
                    server.shutdown()
                }
                appScope.cancel("Application closed")
                appScope.coroutineContext.job.cancel()
            } catch (_: CancellationException) {
            }
        }
        Fancam.info(Tags.Shutdown) { "Server shutdown complete." }
    })
}
