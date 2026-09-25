package encore.fancam.events

/**
 * Specify 6 (5 usable) levels of logging circumstances.
 *
 * - Level 1 [Trace]: Used to log verbose detail of a system, an algorithm-level logging.
 * - Level 2 [Debug]: A primarily developer-facing log level to monitor a system
 *                    during development.
 * - Level 3 [Info]: Generally useful information for anyone operating the server.
 *                   Use for high-level system information.
 * - Level 4 [Warn]: Whenever the system exhibits odd or unusual behavior but is
 *                   non-fatal and recoverable.
 * - Level 5 [Error]: Any error which is fatal to an operation. A log event with error
 *                    level usually needs an operator/developer intervention.
 *
 * The log level [Off] is not used for logging call but rather utilized as a sentinel
 * value to limit the log levels under it.
 */
enum class Level {
    Trace, Debug, Info, Warn, Error, Off
}

/**
 * Convert a string representing one of the log level into the [Level] enum representation.
 *
 * The conversion follows the level word as is, ignoring any case. An invalid string
 * result the conversion to [Level.Trace].
 */
fun String.toLogLevel(): Level {
    return when (this.lowercase()) {
        "trace" -> Level.Trace
        "debug" -> Level.Debug
        "info" -> Level.Info
        "warn" -> Level.Warn
        "error" -> Level.Error
        "off" -> Level.Off
        else -> Level.Trace
    }
}

/**
 * Returns the label representation of this [Level].
 */
fun Level.label(): String {
    return when (this) {
        Level.Trace -> "TRACE"
        Level.Debug -> "DEBUG"
        Level.Info -> "INFO "
        Level.Warn -> "WARN "
        Level.Error -> "ERROR"
        Level.Off -> "OFF  "
    }
}
