package testUtils

import java.io.File

/**
 * Create a temp file according to [filenameWithExt] string.
 *
 * This helper utilize [File.createTempFile] and will also delete
 * the file upon program exit with [File.deleteOnExit].
 */
fun String.toTempFile(filenameWithExt: String): File {
    val name = filenameWithExt.split(".")
    return File.createTempFile(name[0], name[1]).also { it.writeText(this) }.also { it.deleteOnExit() }
}
