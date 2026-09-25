package encore.fancam.producer

import encore.fancam.formatter.FancamFormatter
import encore.fancam.formatter.LogEventFancamFormatter
import java.io.FileDescriptor
import java.io.FileOutputStream
import java.io.PrintStream

/**
 * Producer implementation tailored for console output.
 *
 * A formatter is expected for this implementation, which may be
 * - [LogEventFancamFormatter]
 *
 * Produce is implemented with `println` call through [PrintStream].
 */
class ConsoleFancamProducer<T>(private val formatter: FancamFormatter<T>) : FancamProducer<T> {
    private val rawOut = PrintStream(FileOutputStream(FileDescriptor.out), true, Charsets.UTF_8)
    private fun println(msg: String) = rawOut.println(msg)

    override fun produce(event: T) {
        println(formatter.format(event))
    }
}
