package encore.utils

import java.io.File

/**
 * Get a file with rotation capability enabled.
 *
 * Rotation would produce file with patterns like:
 * - `filename-1.ext`
 * - `filename-2.ext`
 * - `filename-3.ext`
 *
 * @param directory The directory of where the files are located.
 * @param filename The filename without extension or rotation number.
 * @param extension File extension without dot.
 * @param maxRotation The number of maximum rotation before cycling back to 1.
 * @param rotateWhen The predicate that resolves whether a file should be rotated or not.
 *
 * @return The specified file which is guaranteed to exists.
 */
fun getRotatedFile(
    directory: String, filename: String,
    extension: String, maxRotation: Int,
    rotateWhen: (File) -> Boolean,
): File {
    val dir = File(directory).also { it.mkdir() }

    // find existing files in directory
    val files = dir.listFiles()
        ?.mapNotNull {
            val match = Regex("""$filename-(\d+)\.$extension""").matchEntire(it.name)
            match?.groupValues?.get(1)?.toInt()?.let { num -> num to it }
        }
        ?: emptyList()

    val matched = files.maxByOrNull { it.first }

    val currentRotation = matched?.first ?: 1
    val file = File(dir, "$filename-$currentRotation.$extension")

    // check if file should be rotated
    if (file.exists() && rotateWhen(file)) {
        // new rotation which cycles from 1 to max and back to 1
        val nextRotation = (currentRotation % maxRotation) + 1
        val nextFile = File(dir, "$filename-$nextRotation.$extension")
        // when rotation cycles back to 1
        if (nextFile.exists()) nextFile.delete()
        nextFile.createNewFile()
        return nextFile
    }

    if (!file.exists()) file.createNewFile()
    return file
}
