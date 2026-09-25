package testUtils

import encore.fancam.Fancam
import encore.fancam.impl.RehearsalFancam

/**
 * Test helper for creating and accessing a shared [RehearsalFancam] instance.
 *
 * This ensures all system components use the same underlying fancam implementation
 * called from the [Fancam] facade.
 *
 * You only need to use this helper whenever you need to assert or inspect logged events.
 *
 * Usage:
 * ```
 * @BeforeTest
 * fun setup() {
 *     // Must be called before running tests to ensure a shared instance
 *     TestFancam.create()
 * }
 *
 * // Access the instance for assertions
 * TestFancam.get().assertLogHas(...)
 *
 * // Clear all recorded logs
 * TestFancam.clear()
 * ```
 *
 * **Details:**
 * The [Fancam] has a hidden dependency of a fancam implementation.
 * This is solved by it having a default implementation of [RehearsalFancam].
 *
 * In tests where we want to assert log calls, we will need access to a concrete
 * `RehearsalFancam`, which the facade doesn't expose. The result is each tests
 * need to create their own `RehearsalFancam`. This won't work consistently until
 * the facade itself store the custom `RehearsalFancam`.
 *
 * This helper provides shorthand to create and initialize the fancam facade.
 *
 * - [create]: Creates new `RehearsalFancam`, and use it to initialize the `Fancam` facade.
 * - [get]: Returns the same `RehearsalFancam`.
 */
object TestFancam {
    private lateinit var fancam: RehearsalFancam

    /**
     * Creates a `RehearsalFancam`, and use it to initialize the `Fancam` facade.
     */
    fun create() {
        fancam = RehearsalFancam()
        Fancam.initialize(fancam)
    }

    /**
     * Returns the previously created fancam.
     * Throws [UninitializedPropertyAccessException] if [create] is not called before.
     */
    fun get() = fancam

    /**
     * Call the [RehearsalFancam.clearAll] which clears all log entries.
     */
    fun clear() {
        fancam.clearAll()
    }
}