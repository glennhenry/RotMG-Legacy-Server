package encore.subunit.scope

/**
 * A server-wide (global) context.
 *
 * Subunits using this scope operate at the server level and may
 * manage shared state or provide global domain functionality.
 *
 * A server component should NOT be modeled as a `Subunit` if:
 * - It serves as infrastructure or a low-level tool (e.g., database, dispatcher).
 * - It does not encapsulate domain logic or enforce business rules.
 * - It is not likely to be called directly from game/domain logic.
 * - It does not represent a meaningful domain concept.
 */
object ServerScope : SubunitScope
