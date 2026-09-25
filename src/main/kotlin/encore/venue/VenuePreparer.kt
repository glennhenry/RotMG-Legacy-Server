package encore.venue

import encore.annotation.runtime.VenueKey
import encore.utils.xml.XMLFlattener
import encore.fancam.Fancam
import encore.fancam.Tags
import java.io.File
import kotlin.reflect.KClass
import kotlin.reflect.KParameter
import kotlin.reflect.full.findAnnotation
import kotlin.reflect.full.primaryConstructor

/**
 * Internal helper responsible for loading and binding configuration.
 *
 * Responsibilities:
 * 1. Parse XML configuration files using [XMLFlattener]
 * 2. Bind flattened keys to configuration data classes via reflection
 * 3. Override values using environment variables when present
 *
 * @param venueFiles List of configuration files to process.
 * @param envProvider Component that provides environment variables, intended for unit testing.
 */
class VenuePreparer(
    venueFiles: List<File>,
    private val envProvider: EnvProvider = SystemEnvProvider()
) {
    private val flattener = XMLFlattener()
    private val finalKeys = mutableMapOf<String, String>()
    private val usedKeys = mutableSetOf<String>()

    init {
        for (file in venueFiles) {
            processXml(file).forEach { (k, v) ->
                if (k in finalKeys) {
                    Fancam.warn(Tags.Venue) { "Duplicate configuration key detected: '$k'. Last value wins $v." }
                }
                finalKeys[k] = v
            }
        }
        Fancam.info(Tags.Venue) { "Venue configuration loaded successfully (${finalKeys.size} total entries)." }
    }

    /**
     * Get the instantiated data class via [bind].
     *
     * @param clazz The data class by `ClassName::class`.
     * @param category The top-level config category derived from XML tag which
     *                 is either `encore`, `custom`, and `secret` ([VenueCategory]).
     * @param envPrefix The prefix to define an environment variable, to avoid conflict.
     * @throws IllegalStateException May throw exception, see [bind].
     */
    fun <T : Any> get(
        clazz: KClass<T>,
        category: String,
        envPrefix: String = ENCORE_ENV_PREFIX
    ): T {
        val categoryPrefix = "$VENUE_ROOT_TAG.$category"
        val hasSomethingDefined = finalKeys.any { it.key.startsWith("$categoryPrefix.") }

        if (!hasSomethingDefined) {
            val constructor = clazz.primaryConstructor
                ?: error("${clazz.simpleName} must have a primary constructor")

            val hasRequiredField = constructor.parameters.any { !it.isOptional }
            if (hasRequiredField) {
                throw IllegalStateException(
                    "Got '$category' but nothing is defined in <$category> under <$VENUE_ROOT_TAG>."
                )
            }

            return constructor.callBy(emptyMap())
        }

        return bind(finalKeys, categoryPrefix, envPrefix, clazz, usedKeys)
    }

    /**
     * Check whether all listed config on XML are used for data class binding.
     * This will print a warning of all unused configuration keys.
     */
    fun validate() {
        val unused = finalKeys.keys - usedKeys
        if (unused.isEmpty()) return

        Fancam.warn(Tags.Venue) {
            buildString {
                appendLine("Unused configuration keys detected:")
                unused.sortedBy { it.length }.forEach {
                    appendLine("    - $it")
                }
                appendLine("Don't forget to modify 'EncoreConfig', 'CustomConfig', or 'SecretConfig' if you are adding new things.")
            }
        }
    }

    private fun processXml(file: File): Map<String, String> {
        val resultVenue = flattener
            .flatten(file, VENUE_ROOT_TAG)
            .toMutableMap()

        return resultVenue
    }

    /**
     * Bind a flat key-value [map] into the respective data class definition by [clazz].
     *
     * Binding relies on the path key in [VenueKey] annotation to find the
     * corresponding value in the [map].
     *
     * During the binding process, it will also try checking if an environment variable
     * is defined for the same key. If it is, the environment value will take precedence.
     *
     * @throws IllegalStateException When:
     *  1. [clazz] does not have primary constructor.
     *  2. [clazz] does not annotate all non-data value with [VenueKey].
     *  3. Config key is missing from [map], data class does not have a default value, and
     *     environment variable wasn't present.
     */
    private fun <T : Any> bind(
        map: Map<String, String>,
        xmlFieldPrefix: String,
        envPrefix: String,
        clazz: KClass<T>,
        usedKeys: MutableSet<String>
    ): T {
        val constructor = clazz.primaryConstructor!!
        val args = mutableMapOf<KParameter, Any?>()

        for (param in constructor.parameters) {
            val type = param.type.classifier as KClass<*>

            // nested config
            if (type.isData) {
                args[param] = bind(map, xmlFieldPrefix, envPrefix, type, usedKeys)
                continue
            }

            val keyAnn = param.findAnnotation<VenueKey>()
                ?: error("Field is value but missing @VenueKey on ${clazz.simpleName}.${param.name}")

            val key = "$xmlFieldPrefix.${keyAnn.path}"
            val value = checkEnv(key, xmlFieldPrefix, envPrefix) ?: map[key]

            // not found in XML and ENV
            if (value == null) {
                // not found and no default
                if (!param.isOptional) {
                    throw IllegalStateException(
                        "Config value: $key is missing from XML and ENV."
                    )
                }
                // not found in XML, but have default
                Fancam.trace(Tags.Venue) { "Defaulted: ${keyAnn.path}" }
                continue
            }

            usedKeys += key
            args[param] = convert(value, type)
        }

        return constructor.callBy(args)
    }

    /**
     * Check whether environment variable is defined for the [key].
     *
     * @return The defined value. `null` if it's not defined.
     */
    private fun checkEnv(key: String, xmlFieldPrefix: String, envPrefix: String): String? {
        val envKey = pathkeyToEnv(key, xmlFieldPrefix, envPrefix)
        val env = envProvider.get(envKey)
        if (env != null) {
            Fancam.trace(Tags.Venue) { "Overriden by ENV: $envKey" }
        }
        return env
    }

    private fun pathkeyToEnv(path: String, xmlFieldPrefix: String, envPrefix: String): String {
        val trimmed = path.removePrefix("$xmlFieldPrefix.")
        return (envPrefix + "_" + trimmed.replace(".", "_")).uppercase()
    }

    /**
     * @throws IllegalStateException if the target type is not supported.
     */
    private fun convert(value: String, type: KClass<*>): Any {
        return when (type) {
            String::class -> value
            Int::class -> value.toInt()
            Boolean::class -> value.toBoolean()
            Long::class -> value.toLong()
            Double::class -> value.toDouble()
            Float::class -> value.toFloat()
            else -> error("Unsupported config type: ${type.simpleName}")
        }
    }
}
