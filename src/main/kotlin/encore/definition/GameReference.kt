package encore.definition

import encore.definition.GameReference.get
import encore.definition.GameReference.initialize
import encore.fancam.Fancam
import encore.fancam.Tags
import encore.time.TimeCenter
import encore.utils.support.className
import kotlin.reflect.KClass
import kotlin.time.Duration.Companion.milliseconds

/**
 * A global registry of game definitions.
 *
 * Each [GameDefinition] encapsulates rules, policies, or static data
 * describing some aspect of the game.
 *
 * This class act as a registry and provides a lookup for particular game definition.
 * - Registration of definitions via [initialize].
 * - Lookup of definitions via [get].
 *
 * Typical usage:
 * ```
 * GameReference.initialize {
 *     add(XmlRes("boss.xml"), XmlLoader())
 *     add(JsonRes("items.json"), JsonLoader())
 * }
 *
 * val bossHp = GameReference.get<BossConfig>().getBossHpFor(bossId)
 * ```
 */
object GameReference {
    private var initializeState = 0

    /**
     * Holds all registered game definitions.
     *
     * Access should generally go through [get]. Direct modification of
     * this map is not intended. Definitions should be registered through [initialize].
     */
    val registry = mutableMapOf<KClass<out Any>, Any>()
        get() = if (initializeState == 0) {
            error("GameReference is not initialized. Call initialize() first.")
        } else {
            field
        }

    /**
     * Initializes the registry by loading definitions from
     * the provided [GameDataSource] and [GameDataLoader] pairs
     * via the DSL [block].
     *
     * Subsequent calls after initialization are ignored with a warning.
     *
     * @param block A DSL context to register sources and loaders.
     */
    fun initialize(block: InitContext.() -> Unit) {
        if (initializeState == 1 || initializeState == 2) {
            Fancam.warn(Tags.Reference) { "GameReference.initialize() called during or after initialization. Ignoring." }
            return
        }
        initializeState = 1

        val start1 = TimeCenter.now()
        Fancam.info(Tags.Reference) { "Initializing GameReference..." }

        val ctx = InitContext()
        ctx.block()
        ctx.entries.forEach { (source, loader) ->
            val start2 = TimeCenter.now()
            val definitions = loader.produce(source)
            val finish2 = (TimeCenter.now() - start2).milliseconds
            Fancam.trace(Tags.Reference) {
                "Loaded '${source.className()}' by '${loader.className()}' in ${finish2}, produced ${definitions.size} definition entries."
            }

            definitions.forEach { registry[it::class] = it }
        }

        Fancam.info(Tags.Reference) { "GameReference initialized in ${(TimeCenter.now() - start1).milliseconds}" }
        initializeState = 2
    }

    /**
     * Retrieves a registered [GameDefinition] of type [T].
     *
     * @throws IllegalArgumentException if the requested definition is not registered.
     */
    inline fun <reified T : Any> get(): T {
        return registry[T::class] as? T
            ?: throw IllegalArgumentException(
                "GameDefintion <${T::class.simpleName}> is not registered. " +
                        "Call GameReference.initialize() and provide the definition first."
            )
    }
}

/**
 * DSL context for registering [GameDataSource] and [GameDataLoader] pairs
 * during [GameReference.initialize].
 */
class InitContext {
    internal val entries = mutableListOf<Pair<GameDataSource, GameDataLoader>>()

    /**
     * Registers a [source] with its corresponding [loader].
     *
     * @param source The raw game data source.
     * @param loader The loader responsible for converting the source into [GameDefinition]s.
     */
    fun add(source: GameDataSource, loader: GameDataLoader) {
        entries += source to loader
    }
}
