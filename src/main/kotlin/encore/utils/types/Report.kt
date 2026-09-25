package encore.utils.types

/**
 * Represents the summary of an operation, capturing success or failure.
 *
 * Use [Report.Ok] when the operation succeeded and [Report.Fail] when it fails.
 *
 * This type shares the similar idea with [Result], but intentionally
 * does not carry any value or a `Throwable`. It is designed for cases where:
 * - The caller requests an operation from another component.
 * - The caller only cares about whether the operation succeeded or failed.
 * - The caller does not expect a value and do not care about the underlying
 *   exception or error details.
 */
sealed interface Report {
    /**
     * Indicates that the operation succeeded.
     */
    data object Ok : Report

    /**
     * Indicates that the operation failed.
     */
    data object Fail : Report
}

/**
 * Returns whether this report is [Ok].
 */
fun Report.isOk(): Boolean = this is Report.Ok

/**
 * Returns whether this report is [Fail].
 */
fun Report.isFail(): Boolean = this is Report.Fail

/**
 * Executes one of the given functions depending on the type of this [Report]
 * and returns its result.
 *
 * Example usage:
 * ```
 * val report: Report = subunit.updateInventory()
 * val message: Response = report.fold(
 *     onOk = { SuccessResponse("Inventory updated") },
 *     onFail = { FailedResponse("Inventory update failed") }
 * )
 * ```
 *
 * @param onOk Lambda to execute when the report is [Report.Ok].
 * @param onFail Lambda to execute when the report is [Report.Fail].
 * @return The execution result of either `onOk` or `onFail`.
 */
inline fun <R> Report.fold(onOk: () -> R, onFail: () -> R): R {
    return when (this) {
        is Report.Ok -> onOk()
        Report.Fail -> onFail()
    }
}

/**
 * Execute [action] only when the report is [Report.Ok].
 * @return The same report object for DSL chaining.
 */
inline fun Report.onOk(action: () -> Unit): Report {
    if (this is Report.Ok) action()
    return this
}

/**
 * Execute [action] only when the report is [Report.Fail].
 * @return The same report object for DSL chaining.
 */
inline fun Report.onFail(action: () -> Unit): Report {
    if (this is Report.Fail) action()
    return this
}

/**
 * Converts a [Result] into a [Report] by:
 * - If [isSuccess] returns [Report.Ok].
 * - If [isFailure] returns [Report.Fail].
 */
fun <T> Result<T>.toReport(): Report {
    return fold(
        onSuccess = { Report.Ok },
        onFailure = { Report.Fail }
    )
}
