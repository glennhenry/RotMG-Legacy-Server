package encore.fancam.producer

import encore.EncoreFancamConfig
import encore.fancam.LOG_FILE_DIRECTORY
import encore.fancam.events.FileRoutableEvent
import encore.fancam.formatter.FancamFormatter
import encore.fancam.formatter.LogEventFancamFormatter
import encore.fancam.formatter.TrackEventFancamFormatter
import encore.utils.getRotatedFile
import encore.utils.mbToBytes

/**
 * Producer implementation tailored for file output.
 *
 * A formatter is expected for this implementation, which may be
 * - [LogEventFancamFormatter]
 * - [TrackEventFancamFormatter]
 *
 * Produce is implemented by appending the result string of the formatter
 * into the event's target file with rotation enabled.
 */
class FileFancamProducer<T>(
    private val config: EncoreFancamConfig,
    private val formatter: FancamFormatter<T>
) : FancamProducer<T> where T : FileRoutableEvent {
    override fun produce(event: T) {
        val filename = event.filename ?: return

        val file = getRotatedFile(
            directory = LOG_FILE_DIRECTORY,
            filename = filename,
            extension = event.extension,
            maxRotation = config.maxFileRotation
        ) { file ->
            file.length() > (config.maxFileSize.mbToBytes())
        }

        val text = formatter.format(event)
        file.appendText("$text\n")
    }
}
