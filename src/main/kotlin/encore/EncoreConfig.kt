package encore

import encore.annotation.runtime.VenueKey
import encore.fancam.events.Level
import game.config.CustomConfig
import game.config.SecretConfig
import game.Globals

/**
 * Definition of config required by the framework.
 * Define them in `venue.xml` or here directly (for default value).
 *
 * This data class is not intended to be extended by user.
 * Use [CustomConfig] or [SecretConfig] instead.
 *
 * @property devMode
 * @property server
 * @property adminEnabled
 * @property database
 * @property fancam
 */
data class EncoreConfig(
    /**
     * Whether to enable development mode, which will enable feature
     * like hot reload and other internal Ktor engine machinery.
     *
     * This will override JVM property `io.ktor.development` and should
     * be set to `false` on deployment.
     */
    @VenueKey("devMode")
    val devMode: Boolean = true,

    val server: EncoreServerConfig,

    /**
     * Whether to enable admin account, which is used for quick and privileged
     * testing in the game, usually can be used by anyone.
     *
     * Having this disabled won't delete admin account, it will just disable
     * any authentication of admin.
     *
     * Credentials are set in code: [Globals].
     */
    @VenueKey("admin._enabled")
    val adminEnabled: Boolean = true,

    val database: EncoreDatabaseConfig,
    val fancam: EncoreFancamConfig
)

/**
 * @property host
 * @property port
 * @property socketPort
 */
data class EncoreServerConfig(
    /**
     * Host URL where this server is serving from.
     */
    @VenueKey("server.host")
    val host: String,

    /**
     * Server port for file and API server.
     */
    @VenueKey("server.port")
    val port: Int,

    /**
     * Server port for socket connection.
     */
    @VenueKey("server.socketPort")
    val socketPort: Int
)

/**
 * Database configuration which is tailored to Mongo
 */
data class EncoreDatabaseConfig(
    /**
     * Database name used in non-tests environment (dev/production)
     */
    @VenueKey("database.mongo.dbname")
    val dbName: String,

    /**
     * Database URL used in non-tests environment (dev/production)
     */
    @VenueKey("database.mongo.dburl")
    val dbUrl: String,
)

/**
 * Fancam (logger) configuration.
 */
data class EncoreFancamConfig(
    /**
     * Filter the minimum level of log messages.
     *
     * Levels: `0: ALL` `1: TRACE` `2: DEBUG` `3: INFO`
     *         `4: WARN` `5: ERROR` `6: NOTHING`
     *
     * e.g., level INFO means only seeing log message with INFO, WARN, ERROR
     */
    @VenueKey("fancam.level")
    val level: String = Level.Trace.name,

    /**
     * Whether to color log messages or output as plain text.
     */
    @VenueKey("fancam.color._enabled")
    val colorEnabled: Boolean = true,

    /**
     * Whether to color the background instead of the fonts
     *
     * Recommend set to `true` in light mode
     */
    @VenueKey("fancam.color.useBackgroundColor")
    val useBackgroundColor: Boolean = true,

    /**
     * Specify the empty space allocation to show a hyperlinked filename.
     */
    @VenueKey("fancam.formatting.fileNamePadding")
    val fileNamePadding: Int = 25,

    /**
     * Specify the empty space allocation to show the tag of log message.
     */
    @VenueKey("fancam.formatting.tagPadding")
    val tagPadding: Int = 10,

    /**
     * Maximum message length for a single line (by `\n`)
     * if `logFull=false` in the log event.
     */
    @VenueKey("fancam.formatting.maxLineLength")
    val maxLineLength: Int = 500,

    /**
     * Maximum file size in MB (for all files)
     */
    @VenueKey("fancam.formatting.maxFileSize")
    val maxFileSize: Int = 5,

    /**
     * Maximum file rotation (for all files)
     */
    @VenueKey("fancam.formatting.maxFileRotation")
    val maxFileRotation: Int = 5,
)
