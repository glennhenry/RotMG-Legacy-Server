package encoreTest.acts

import encore.acts.ActConcept
import encore.acts.choreo.BasicChoreography
import encore.acts.choreo.ChoreographyContext
import encore.acts.choreo.PerformMode
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.time.Duration.Companion.milliseconds
import kotlin.time.Duration.Companion.minutes

class BasicChoreographyTest {
    @Test
    fun `once returns initialDelay`() {
        val concept = object : ActConcept {}
        val now = 0L

        val actual = BasicChoreography<ActConcept>(3.minutes, PerformMode.Once)
            .next(concept, ChoreographyContext(now, 0, 0, null, null))

        val expected = (3.minutes).inWholeMilliseconds
        assertEquals(expected, actual)
    }

    @Test
    fun `once has time drift returns lower initialDelay`() {
        val concept = object : ActConcept {}
        val now = 1000L

        val actual = BasicChoreography<ActConcept>(3.minutes, PerformMode.Once)
            .next(concept, ChoreographyContext(now, 0, startedAt = 0L, null, null))

        val expected = (3.minutes - now.milliseconds).inWholeMilliseconds
        assertEquals(expected, actual)
    }

    @Test
    fun `once returns null after performCount = 1`() {
        val concept = object : ActConcept {}
        val now = 0L

        val actual = BasicChoreography<ActConcept>(3.minutes, PerformMode.Once)
            .next(concept, ChoreographyContext(now, 1, 0, null, null))

        val expected = null
        assertEquals(expected, actual)
    }

    @Test
    fun `repeat returns initialDelay on first perform`() {
        val concept = object : ActConcept {}
        val now = 0L

        val actual = BasicChoreography<ActConcept>(3.minutes, PerformMode.Repeat(3, 1.minutes))
            .next(concept, ChoreographyContext(now, 0, 0, null, null))

        val expected = (3.minutes).inWholeMilliseconds
        assertEquals(expected, actual)
    }

    @Test
    fun `repeat returns interval on non-first perform`() {
        val concept = object : ActConcept {}
        // now time has to be equal to initialDelay + performCount for logic to be consistent
        val now = (3.minutes + 2.minutes).inWholeMilliseconds

        val actual = BasicChoreography<ActConcept>(3.minutes, PerformMode.Repeat(3, 1.minutes))
            .next(concept, ChoreographyContext(now, 3, 0, null, null))

        val expected = (1.minutes).inWholeMilliseconds
        assertEquals(expected, actual)
    }

    @Test
    fun `repeat returns null after finish`() {
        val concept = object : ActConcept {}
        val now = 0L

        val actual = BasicChoreography<ActConcept>(3.minutes, PerformMode.Repeat(3, 1.minutes))
            .next(concept, ChoreographyContext(now, 4, 0, null, null))

        val expected = null
        assertEquals(expected, actual)
    }
}
