package game.config

import encore.annotation.runtime.VenueKey

/**
 * Custom application config definition.
 *
 * Place every venue-supplied configuration here, also annotate with [VenueKey].
 * After that, modify `venue.xml` accordingly from this data class entries.
 *
 * All field is preferred to be immutable.
 */
data class CustomConfig(
    val dummy: Int = 0
)
