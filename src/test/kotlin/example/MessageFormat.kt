package example

import encore.network.fanchant.guide.DecodeResult
import encore.network.fanchant.guide.FanchantGuide
import encore.network.fanchant.Fanchant
import kotlin.test.*

/**
 * This file demonstrate a full example of message format implementation and serializer.
 *
 * This test gives an example of how to test a message format.
 */
class SpaceDelimitedStringFormatTest {
    @Test
    fun `test verify format success`() {
        val format = SpaceSeparatedStringFanchantGuide()
        assertTrue(format.verify(byteArrayOf(3.toByte())))
    }

    @Test
    fun `test verify codec fail`() {
        val format = SpaceSeparatedStringFanchantGuide()
        assertFalse(format.verify(byteArrayOf(14.toByte())))
    }

    @Test
    fun `test verify format success but invalid format (even-length)`() {
        val format = SpaceSeparatedStringFanchantGuide()
        val bytes = byteArrayOf(3.toByte(), 3, 4, 4)
        val result = format.tryDecode(bytes)
        assertIs<DecodeResult.Failure>(result)
    }

    @Test
    fun `test decode success`() {
        val format = SpaceSeparatedStringFanchantGuide()
        val bytes = byteArrayOf(8.toByte(), 3, 4, 4, 5, 9, 127, 111, 100)
        val result = format.tryDecode(bytes)
        assertIs<DecodeResult.Success<List<String>>>(result)

        val expected = listOf("8", "3-4", "4-5", "9-127", "111-100")
        val actual = result.value
        assertEquals(expected, actual)
    }

    @Test
    fun `test encode fail invalid string (1 byte in a group)`() {
        val list = listOf("7", "34", "4-5", "9-127", "111-100")
        assertNull(SpaceSeparatedStringSerializer.serialize(list))
    }

    @Test
    fun `test encode fail invalid string (3 byte in a group)`() {
        val list = listOf("9", "34-43-22", "4-5", "9-127", "111-100")
        assertNull(SpaceSeparatedStringSerializer.serialize(list))
    }

    @Test
    fun `test encode fail one of the number is not a byte`() {
        val list = listOf("8", "343-1", "4-5", "9-127", "111-100")
        assertNull(SpaceSeparatedStringSerializer.serialize(list))
    }

    @Test
    fun `test encode success`() {
        val list = listOf("8", "3-4", "4-5", "9-127", "111-100")
        assertContentEquals(byteArrayOf(8, 3, 4, 4, 5, 9, 127, 111, 100), SpaceSeparatedStringSerializer.serialize(list))
    }
}

/**
 * An example implementation of [FanchantGuide].
 * - The network message format operates on a list of string.
 * - Valid raw format is a byte array that is prefixed by some 1-digit header number.
 *   which is the size of message % 9
 * - After that number, everything is byte number (-128 to 127).
 * - The byte array has even length (not including the header) and each number is paired.
 * - We consider the header number (which is the first number in the list)
 *   as the socket message's "type".
 *
 * Example:
 * - **decoded**: `[3 124-94 9-23 51-32]` (string representation)
 * - **encoded**: `[3 124 94 9 23 51 32]` (assume byte representation)
 *
 * **Note**: the decoding logic is implemented on [tryDecode], while the
 * encoding, or the serialization process is on [SpaceSeparatedStringSerializer].
 *
 * **Decoding**:
 * - Drops the header number.
 * - Ensure the size is even. **FAIL: return null**.
 * - For each byte group them into two, then ensure all bytes are valid
 *   (number between -127 and 128). **FAIL: return null**.
 * - Turn each byte group into string like `<b1>-<b2>`.
 *
 * **Encoding**:
 * - Create header number which is the size of input * 2 % 9.
 * - Create byte array, include the header number first.
 * - For each string, split with '-', then ensure each number
 *   is a valid byte. **FAIL: return null**.
 * - Add all bytes to the byte array.
 */
class SpaceSeparatedStringFanchantGuide : FanchantGuide<List<String>> {
    override fun verify(data: ByteArray): Boolean {
        return data.first().toInt() in 0..9
    }

    override fun tryDecode(data: ByteArray): DecodeResult<List<String>> {
        val header = data.first()
        if (header.toInt() !in -127..128) {
            return DecodeResult.Failure(reason = "Header out of bounds")
        }
        val withoutHeader = data.drop(1)
        if (withoutHeader.size % 2 != 0) {
            return DecodeResult.Failure(reason = "Payload length is not even")
        }

        val result = mutableListOf(header.toString())

        val iterator = withoutHeader.iterator()
        while (iterator.hasNext()) {
            val b1 = iterator.next()
            if (!iterator.hasNext()) {
                return DecodeResult.Failure(reason = "Payload length is even, but missing halfway")
            }
            val b2 = iterator.next()
            result.add("${b1}-${b2}")
        }

        return DecodeResult.Success(result)
    }

    override fun materialize(decoded: List<String>): Fanchant {
        return SpaceSeparatedFanchant(decoded)
    }
}

/**
 * Serializer implementation for the [SpaceSeparatedStringFanchantGuide].
 */
object SpaceSeparatedStringSerializer {
    fun serialize(input: List<String>): ByteArray? {
        val header = ((input.size - 1) * 2) % 9
        val result = mutableListOf(header.toByte())

        input.drop(1).filter {
            val group = it.split("-")
            if (group.size != 2) return null

            val b1 = group[0]
            val b2 = group[1]

            if (b1.toIntOrNull() == null) return null
            if (b2.toIntOrNull() == null) return null

            if (b1.toInt() !in -127..128) return null
            if (b2.toInt() !in -127..128) return null

            true
        }.forEach {
            val group = it.split("-")
            result.add(group[0].toByte())
            result.add(group[1].toByte())
        }

        return result.toByteArray()
    }
}

/**
 * Example [Fanchant] implementation based on [SpaceSeparatedStringFanchantGuide].
 */
class SpaceSeparatedFanchant(private val payload: List<String>): Fanchant {
    override val type: String = payload.first()
    override fun toString(): String = payload.joinToString()
}
