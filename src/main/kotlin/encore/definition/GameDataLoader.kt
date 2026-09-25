package encore.definition

/**
 * Loads and interprets a [GameDataSource] into one or more [GameDefinition]s.
 *
 * Implementations are responsible for reading, decoding, and transforming
 * raw data into structured, domain-specific definitions.
 */
interface GameDataLoader {
    /**
     * Produces [GameDefinition]s from the given [GameDataSource].
     */
    fun produce(source: GameDataSource): List<GameDefinition>
}
