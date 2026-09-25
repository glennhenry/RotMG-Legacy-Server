package encoreTest.acts

import encore.acts.ActConcept
import encore.acts.choreo.ChoreographyContext
import encore.acts.choreo.DailyChoreography
import encore.time.model.at
import java.time.ZoneId
import java.time.ZonedDateTime
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.time.Duration.Companion.hours
import kotlin.time.Duration.Companion.minutes
import kotlin.time.Duration.Companion.seconds

class DailyChoreographyTest {
    @Test
    fun `daily choreo becomes today`() {
        val concept = object : ActConcept {}
        val zone = ZoneId.of("UTC")
        val now = ZonedDateTime.of(
            2026, 5, 9,
            14, 0, 0, 0,
            zone
        ).toInstant().toEpochMilli()

        val actual = DailyChoreography<ActConcept>(15.at(30), zone)
            .next(concept, ChoreographyContext(now, 0,  0, null, null))

        val expected = (1.hours + 30.minutes).inWholeMilliseconds
        assertEquals(expected, actual)
    }

    @Test
    fun `daily choreo slightly before becomes today`() {
        val concept = object : ActConcept {}
        val zone = ZoneId.of("UTC")
        val now = ZonedDateTime.of(
            2026, 5, 9,
            15, 29, 59, 0,
            zone
        ).toInstant().toEpochMilli()

        val actual = DailyChoreography<ActConcept>(15.at(30), zone)
            .next(concept, ChoreographyContext(now, 0,  0, null, null))

        val expected = (1.seconds).inWholeMilliseconds
        assertEquals(expected, actual)
    }

    @Test
    fun `daily choreo becomes tomorrow`() {
        val concept = object : ActConcept {}
        val zone = ZoneId.of("UTC")
        val now = ZonedDateTime.of(
            2026, 5, 9,
            16, 30, 0, 0,
            zone
        ).toInstant().toEpochMilli()

        val actual = DailyChoreography<ActConcept>(15.at(30), zone)
            .next(concept, ChoreographyContext(now, 0,  0, null, null))

        val expected = (23.hours).inWholeMilliseconds
        assertEquals(expected, actual)
    }

    @Test
    fun `daily choreo slightly after becomes tomorrow`() {
        val concept = object : ActConcept {}
        val zone = ZoneId.of("UTC")
        val now = ZonedDateTime.of(
            2026, 5, 9,
            15, 30, 1, 0,
            zone
        ).toInstant().toEpochMilli()

        val actual = DailyChoreography<ActConcept>(15.at(30), zone)
            .next(concept, ChoreographyContext(now, 0,  0, null, null))

        val expected = (24.hours - 1.seconds).inWholeMilliseconds
        assertEquals(expected, actual)
    }

    @Test
    fun `daily choreo exactly now becomes today`() {
        val concept = object : ActConcept {}
        val zone = ZoneId.of("UTC")
        val now = ZonedDateTime.of(
            2026, 5, 9,
            15, 30, 0, 0,
            zone
        ).toInstant().toEpochMilli()

        val actual = DailyChoreography<ActConcept>(15.at(30), zone)
            .next(concept, ChoreographyContext(now, 0,  0, null, null))

        assertEquals(0L, actual)
    }
}
