@file:Suppress("ConstPropertyName", "unused")

package game

import encore.EncoreIdentity

/**
 * Defines identity of this server implementation.
 *
 * Provides cosmetic, code-level details such as product name and version.
 *
 * This information is optional and used only for presentation,
 * for example in server startup banners or log messages.
 *
 * See banner: [EncoreIdentity]
 *
 * - [Title]: could be the game name, such as "XYZ Revived".
 * - [Version]: version of this server implementation.
 * - [Description]: descriptive texts.
 */
object GameIdentity {
    const val Title = "Unnamed"
    const val Version = "0.0.1"
    const val Description = ""
}
