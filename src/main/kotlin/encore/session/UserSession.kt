package encore.session

import kotlin.time.Duration

/**
 * Representation of a user's session.
 *
 * @property userId User's unique identifier to which this session belongs to.
 * @property token A unique prove for authentication.
 * @property baseDuration The duration of a single session without any refresh.
 * @property issuedAt Epoch millis when this session was created.
 * @property expiresAt Epoch millis when this session is no longer valid.
 * @property lifetime Epoch millis of token's total validity if refreshed regularly.
 */
data class UserSession(
    val userId: String,
    val token: String,
    val baseDuration: Duration,
    val issuedAt: Long,
    var expiresAt: Long,
    var lifetime: Long,
)
