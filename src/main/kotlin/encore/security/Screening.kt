package encore.security

import encore.fancam.Fancam
import encore.fancam.Tags

/**
 * A DSL-style sequential validation pipeline (guard-chain).
 *
 * `Screening` executes a series of ordered validation checks.
 * Each check evaluates a predicate, and optionally executes a failure handler.
 *
 * Execution stops immediately on the first failed check and subsequent checks are skipped.
 *
 * Example:
 * ```kotlin
 * val str = "user@email.com"
 * var failedResponse: Response? = null
 *
 * Screening("EmailCheck")
 *     .check("Contains @", { str.contains("@") }) {
 *         failedResponse = Response("Email invalid without '@'")
 *     }
 *     .check("Minimum 10 length", { str.length >= 10 }) {
 *         failedResponse = Response("Email too short")
 *     }
 *
 * failedResponse?.let { return it }
 * ```
 *
 * Execution rules:
 * - Checks are evaluated sequentially by call order.
 * - Evaluation stops at the first failed predicate (`false` result).
 * - When a predicate fails, its `onFail` block is executed.
 * - If a check throws, execution aborted and error is re-thrown.
 * - If a predicate throws an exception:
 *     - it is treated as a runtime error (not a validation failure)
 *     - execution is aborted immediately
 *     - the exception is rethrown
 *     - `onFail` will **not** be executed
 *
 * Note: if either [check] or `onFail` handler contains any suspendable call,
 * the [checkSuspend] should be used instead.
 *
 * @param title Descriptive name of this screening (e.g., "BuildingCreate")
 * @param target Logical target of this screening (e.g., `playerId`, `username`)
 */
class Screening(
    private val title: String,
    private val target: String = "",
) {
    private var stageIndex: Int = 1
    private var failed = false

    /**
     * Perform a non-suspendable validation check.
     *
     * Behavior:
     * - If predicate returns `true`, the check passes and execution continues.
     * - If predicate returns `false`, the check fails and `onFail` is executed.
     * - If predicate throws an exception:
     *     - treated as a runtime error
     *     - execution is aborted immediately
     *     - exception is rethrown
     *     - `onFail` is **NOT** executed
     *
     * @param description Descriptive text of the condition being checked.
     * @param predicate Validation condition that must return `true` to pass.
     * @param onFail Handler block that executes when predicate returns false.
     */
    fun check(
        description: String,
        predicate: () -> Boolean,
        onFail: () -> Unit
    ): Screening {
        if (failed) return this

        val stageDescription = if (description.isBlank()) "stage-$stageIndex" else "stage-$stageIndex: $description"
        val stageTarget = target.ifBlank { "Undefined" }

        val passed = try {
            predicate()
        } catch (e: Throwable) {
            Fancam.error(e, Tags.Screening) {
                "Screening '$title' scandal at $stageDescription (target=$stageTarget): ${e.message}"
            }
            throw e
        }

        if (!passed) {
            Fancam.info(Tags.Screening) { "Screening '$title' failed at $stageDescription (target=$stageTarget)" }
            failed = true
            onFail()
        }

        Fancam.trace(Tags.Screening) { "Screening '$title' passed $stageDescription (target=$stageTarget)" }

        stageIndex += 1
        return this
    }

    /**
     * Suspendable version of [check].
     */
    suspend fun checkSuspend(
        description: String,
        predicate: suspend () -> Boolean,
        onFail: suspend () -> Unit
    ): Screening {
        if (failed) return this

        val stageDescription = if (description.isBlank()) "stage-$stageIndex" else "stage-$stageIndex: $description"
        val stageTarget = target.ifBlank { "Undefined" }

        val passed = try {
            predicate()
        } catch (e: Throwable) {
            Fancam.error(e, Tags.Screening) {
                "Screening '$title' scandal at $stageDescription (target=$stageTarget): ${e.message}"
            }
            throw e
        }

        if (!passed) {
            Fancam.info(Tags.Screening) { "Screening '$title' failed at $stageDescription (target=$stageTarget)" }
            failed = true
            onFail()
        }

        Fancam.trace(Tags.Screening) { "Screening '$title' passed $stageDescription (target=$stageTarget)" }

        stageIndex += 1
        return this
    }
}