package encore.session

import encore.fancam.Fancam
import encore.fancam.Tags
import encore.subunit.Subunit
import encore.subunit.scope.ServerScope
import encore.time.TimeCenter
import encore.time.source.MutableTimeSource
import encore.time.source.TimeSource
import game.Globals
import encore.utils.identifier.Ids
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Job
import kotlinx.coroutines.cancelAndJoin
import kotlinx.coroutines.delay
import kotlinx.coroutines.isActive
import kotlinx.coroutines.launch
import java.util.concurrent.ConcurrentHashMap
import kotlin.coroutines.EmptyCoroutineContext
import kotlin.time.Duration
import kotlin.time.Duration.Companion.hours
import kotlin.time.Duration.Companion.minutes

/**
 * Server-scoped subunit responsible to manages sessions of online users.
 *
 * A [UserSession] is identified by `userId` and verification is done with UUID.
 *
 * - Use [create] to generate a session.
 * - Use [verify] passing a token to verify the session's validity.
 * - Use [refresh] to extend the session's duration.
 *
 * @param parentScope The parent coroutine scope that holds the lifecycle.
 * @param timeSource [TimeSource] implementation used to provide time.
 */
class SessionSubunit(
    private val parentScope: CoroutineScope,
    private val timeSource: TimeSource,
) : Subunit<ServerScope> {
    // token to UserSession
    private val sessions = ConcurrentHashMap<String, UserSession>()
    private val cleanUpInterval = 20.minutes
    private val cleanupJob: Job

    init {
        cleanupJob = parentScope.launch {
            while (isActive) {
                delay(cleanUpInterval)
                cleanupExpiredSessions()
            }
        }
    }

    /**
     * Create a session for the [userId] with:
     * - base duration of [validFor], default 1 hour.
     * - lifetime of [lifetime], default 6 hours.
     */
    fun create(userId: String, validFor: Duration = 1.hours, lifetime: Duration = 6.hours): UserSession {
        val now = timeSource.now()

        val token = if (userId == Globals.ADMIN_PLAYER_ID) {
            Globals.ADMIN_TOKEN
        } else {
            Ids.uuid()
        }

        val session = UserSession(
            userId = userId,
            token = token,
            baseDuration = validFor,
            issuedAt = now,
            expiresAt = now + validFor.inWholeMilliseconds,
            lifetime = lifetime.inWholeMilliseconds
        )

        sessions[token] = session
        return session
    }

    /**
     * Verify the validity of session associated with the [token].
     *
     * This checks whether the token is valid:
     * - the token was issued before
     * - the token doesn't expire yet
     *
     * @return `true` if session is valid, `false` otherwise.
     */
    fun verify(token: String): Boolean {
        val session = sessions[token] ?: return false
        val now = timeSource.now()

        return now < session.expiresAt
    }

    /**
     * Refresh a session associated with the [token].
     *
     * Before refreshing, the token is checked:
     * - if it was issued before
     * - doesn't exceed the maximum lifetime
     *
     * @return `true` if session was successfully refreshed, `false` otherwise.
     */
    fun refresh(token: String): Boolean {
        val session = sessions[token] ?: return false
        val now = timeSource.now()

        val usedLifetime = now - session.issuedAt
        if (usedLifetime > session.lifetime) {
            sessions.remove(token)
            return false
        }

        session.expiresAt = now + session.baseDuration.inWholeMilliseconds
        return true
    }

    /**
     * Get the `userId` associated with this [token].
     *
     * The token is valid when:
     * - the token was issued before
     * - the token doesn't expire yet
     *
     * @return `null` if the token is invalid.
     */
    fun getUserId(token: String): String? {
        return sessions[token]?.takeIf {
            TimeCenter.isAfterNow(it.expiresAt, timeSource)
        }?.userId
    }

    /**
     * Cleanup expired sessions which has exceeded the maximum lifetime
     * and can't be refreshed anymore.
     */
    private fun cleanupExpiredSessions() {
        val now = timeSource.now()
        val oldSize = sessions.size
        sessions.entries.removeIf { (_, session) ->
            now - session.issuedAt > session.lifetime
        }
        val newSize = sessions.size
        Fancam.trace(Tags.Session) { "Scheduled sessions cleanup (${newSize - oldSize} sessions removed)" }
    }

    override suspend fun debut(scope: ServerScope): Result<Unit> = Result.success(Unit)
    override suspend fun disband(scope: ServerScope): Result<Unit> {
        return runCatching {
            cleanupJob.cancelAndJoin()
            sessions.clear()
            return Result.success(Unit)
        }
    }

    companion object {
        /**
         * Creates a test instance of [SessionSubunit].
         *
         * @param parentScope scope used for lifecycle and cleanup job (e.g., `TestScope`).
         * @param timeSource time model used to control session timing (e.g., [MutableTimeSource]).
         */
        fun createForTest(
            parentScope: CoroutineScope = CoroutineScope(EmptyCoroutineContext),
            timeSource: TimeSource = MutableTimeSource()
        ): SessionSubunit {
            return SessionSubunit(parentScope, timeSource)
        }
    }
}
