package encore.venue

/**
 * Defines component that provides environment variables.
 *
 * This is used in unit tests because we can't set env from code.
 */
interface EnvProvider {
    /**
     * Get the [name] environment variable.
     */
    fun get(name: String): String?
}

/**
 * Provides env from [System.getenv].
 */
class SystemEnvProvider: EnvProvider {
    override fun get(name: String): String? {
        return System.getenv(name)
    }
}

/**
 * Provides env from a fake map (for unit tests).
 */
class FakeEnvProvider(private val map: Map<String, String>): EnvProvider {
    override fun get(name: String): String? {
        return map[name]
    }
}
