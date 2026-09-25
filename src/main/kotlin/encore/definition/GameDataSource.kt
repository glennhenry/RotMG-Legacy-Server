package encore.definition

/**
 * Provides access to static resources which stores the raw game data.
 *
 * A `GameDataSource` abstracts how data is stored and retrieved,
 * regardless of its underlying format (e.g. JSON, XML, binary).
 *
 * It does not interpret the data; loaders such as [GameDataLoader]
 * are responsible for parsing it into [GameDefinition]s.
 */
interface GameDataSource {
    /**
     * Path to the resource file.
     */
    val path: String

    /**
     * Reads the content as a UTF-8 string (for text-based formats).
     */
    fun readText(): String

    /**
     * Reads the raw content of this resource as a byte array.
     */
    fun readBytes(): ByteArray
}
