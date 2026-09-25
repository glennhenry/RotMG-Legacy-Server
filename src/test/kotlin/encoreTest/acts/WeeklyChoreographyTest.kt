package encoreTest.acts

import encore.acts.ActConcept
import encore.acts.choreo.ChoreographyContext
import encore.acts.choreo.WeeklyChoreography
import encore.time.model.DayOfWeek
import encore.time.model.at
import java.time.ZoneId
import java.time.ZonedDateTime
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.time.Duration.Companion.days
import kotlin.time.Duration.Companion.hours

class WeeklyChoreographyTest {
    /*
        Monday     4  May 2026
        Tuesday    5  May 2026
        Wednesday  6  May 2026
        Thursday   7  May 2026
        Friday     8  May 2026
        Saturday   9  May 2026
        Sunday     10 May 2026
     */

    @Test
    fun `weekly choreo becomes today`() {
        val concept = object : ActConcept {}
        val zone = ZoneId.of("UTC")
        val now = ZonedDateTime.of(
            2026, 5, 4,
            14, 30, 0, 0,
            zone
        ).toInstant().toEpochMilli()

        val actual = WeeklyChoreography<ActConcept>(DayOfWeek.Monday, 15.at(30), zone)
            .next(concept, ChoreographyContext(now, 0,  0, null, null))

        val expected = (1.hours).inWholeMilliseconds
        assertEquals(expected, actual)
    }

    @Test
    fun `weekly choreo becomes tomorrow`() {
        val concept = object : ActConcept {}
        val zone = ZoneId.of("UTC")
        val now = ZonedDateTime.of(
            2026, 5, 4,
            14, 30, 0, 0,
            zone
        ).toInstant().toEpochMilli()

        val actual = WeeklyChoreography<ActConcept>(DayOfWeek.Tuesday, 15.at(30), zone)
            .next(concept, ChoreographyContext(now, 0,  0, null, null))

        val expected = (1.days + 1.hours).inWholeMilliseconds
        assertEquals(expected, actual)
    }

    @Test
    fun `weekly choreo becomes next week`() {
        val concept = object : ActConcept {}
        val zone = ZoneId.of("UTC")
        val now = ZonedDateTime.of(
            2026, 5, 4,
            16, 30, 0, 0,
            zone
        ).toInstant().toEpochMilli()

        val actual = WeeklyChoreography<ActConcept>(DayOfWeek.Monday, 15.at(30), zone)
            .next(concept, ChoreographyContext(now, 0,  0, null, null))

        val expected = (7.days - 1.hours).inWholeMilliseconds
        assertEquals(expected, actual)
    }
}
