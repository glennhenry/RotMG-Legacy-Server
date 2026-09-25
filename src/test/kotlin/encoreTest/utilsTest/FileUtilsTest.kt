package encoreTest.utilsTest

import encore.utils.getRotatedFile
import java.io.File
import java.nio.file.Path
import kotlin.io.path.ExperimentalPathApi
import kotlin.io.path.absolutePathString
import kotlin.io.path.createTempDirectory
import kotlin.io.path.deleteRecursively
import kotlin.test.AfterTest
import kotlin.test.BeforeTest
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertTrue

class FileUtilsTest {
    lateinit var tempDir: String
    lateinit var tempDirRef: Path

    @BeforeTest
    fun createDir() {
        tempDirRef = createTempDirectory(".test")
        tempDir = tempDirRef.absolutePathString()
    }

    @OptIn(ExperimentalPathApi::class)
    @AfterTest
    fun cleanup() {
        tempDirRef.deleteRecursively()
    }

    @Test
    fun `creates file with rotation-1 when none exists`() {
        val file = getRotatedFile(
            directory = tempDir,
            filename = "testFileUtils",
            extension = "abc",
            maxRotation = 3,
            rotateWhen = { false }
        )

        assertTrue(file.exists())
        assertEquals("testFileUtils-1.abc", file.name)
    }

    @Test
    fun `rotates when condition is true`() {
        File(tempDir, "testFileUtils-1.abc").also { it.createNewFile() }
        val file = getRotatedFile(
            directory = tempDir,
            filename = "testFileUtils",
            extension = "abc",
            maxRotation = 3,
            rotateWhen = { true }
        )

        assertTrue(file.exists())
        assertEquals("testFileUtils-2.abc", file.name)
    }

    @Test
    fun `does not rotate when condition is false`() {
        File(tempDir, "testFileUtils-1.abc").also { it.createNewFile() }
        val file = getRotatedFile(
            directory = tempDir,
            filename = "testFileUtils",
            extension = "abc",
            maxRotation = 3,
            rotateWhen = { false }
        )

        assertTrue(file.exists())
        assertEquals("testFileUtils-1.abc", file.name)
    }

    @Test
    fun `cycles back to 1 after maxRotation is reached`() {
        // should still rotate even if 1 and 2 is unavailable
        File(tempDir, "testFileUtils-3.abc").also { it.createNewFile() }

        val file = getRotatedFile(
            directory = tempDir,
            filename = "testFileUtils",
            extension = "abc",
            maxRotation = 3,
            rotateWhen = { true }
        )

        assertTrue(file.exists())
        assertEquals("testFileUtils-1.abc", file.name)
    }
}
