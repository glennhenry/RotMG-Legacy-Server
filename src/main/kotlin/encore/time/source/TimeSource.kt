package encore.time.source

/**
 * Represent an abstraction to a source of time.
 *
 * `TimeSource` is a low-level component that figures the way the system gets reference to time.
 * It decouples a system that depends on time with the underlying source.
 * This unlock an ability such as to provide a fake time which is controlled manually.
 *
 * Implementations:
 * - [SystemTimeSource] based on real system time.
 * - [MutableTimeSource] allows alteration of time.
 * - [ScaledTimeSource] returns a scaled version of the time.
 * - [PausableTimeSource] able to pause/resume time model.
 */
interface TimeSource {
    /**
     * [TimeController] implementation.
     * This is typically implemented by the same [TimeSource] implementation itself.
     */
    val controller: TimeController

    /**
     * Return the current time in millis.
     */
    fun now(): Long
}
