package bootstrap

import encore.fancam.Fancam
import encore.fancam.Tags
import encore.venue.Venue
import java.io.File

/**
 * Log the startup informations.
 */
fun logStartupInformation() {
    val serverHost = Venue.encore.server.host
    val apiPort = Venue.encore.server.port

    Fancam.info(Tags.Startup) { "Server and framework components initialized." }
    Fancam.info(Tags.Startup) { "File/API served at (${serverHost}:$apiPort)." }
    Fancam.info(Tags.Startup) { "Devtools served at (${serverHost}:$apiPort/backstage)." }

    if (File("docs_build/index.html").exists()) {
        Fancam.info(Tags.Startup) { "Docs website available on ${serverHost}:$apiPort." }
    } else {
        Fancam.info(Tags.Startup) { "Docs website not available. Optionally, run 'npm install' & 'npm run dev' in the docs folder to preview it." }
    }
}
