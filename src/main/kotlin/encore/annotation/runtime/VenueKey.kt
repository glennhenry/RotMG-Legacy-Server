package encore.annotation.runtime

import encore.EncoreConfig
import game.config.CustomConfig
import game.config.SecretConfig

/**
 * Used to annotate [EncoreConfig], [CustomConfig], and [SecretConfig]
 * to define their corresponding XML path, allowing custom structure in
 * data class without a requirement to follow the XML structure.
 *
 * The following XML:
 *
 * ```xml
 * <parent>
 *     <child enabled="true">
 *         <value>123</value>
 *     </child>
 * </parent>
 * ```
 *
 * can be defined as a single data class
 *
 * ```kotlin
 * data class ParentConfig(
 *     @VenueKey("parent.child._enabled")
 *     val childEnabled: Boolean
 *
 *     @VenueKey("parent.child.value")
 *     val childValue: Int
 * )
 * ```
 *
 * @property path Represent path to the XML structure.
 *
 */
@Target(AnnotationTarget.VALUE_PARAMETER)
@Retention(AnnotationRetention.RUNTIME)
annotation class VenueKey(val path: String)
