package example

import com.mongodb.client.model.Filters
import com.mongodb.client.model.Updates
import com.mongodb.kotlin.client.coroutine.MongoCollection
import encore.account.FieldPlayerId
import encore.datastore.DocumentNotFoundException
import game.mongo.collection.PlayerId
import encore.datastore.runMongoCatching
import encore.datastore.throwIfNothingMatched
import encore.fancam.Fancam
import encore.subunit.Subunit
import encore.subunit.helper.failHandleGet
import encore.subunit.helper.failHandleUpdate
import encore.subunit.scope.PlayerScope
import encore.utils.types.Outcome
import encore.utils.types.Report
import encore.utils.types.isOk
import encore.utils.types.okOrNull
import encore.utils.types.toOutcome
import encore.utils.types.toReport
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.firstOrNull
import kotlinx.coroutines.test.runTest
import initMongo
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertTrue

/**
 * This file demonstrate a full example of handler-subunit-repository integration.
 *
 * This test gives example of how to test a subunit.
 */
class ExampleSubunitTest {
    /**
     * Principle:
     * - Repository is typically not tested since it only contains call to the
     *   underlying database and domain logic is operated on subunit.
     * - Test subunits operation that contains domain and processing logic.
     *   A simple get methods that depends on repository solely without additional
     *   logic may not need to be tested.
     * - Repository should be mocked, purposedly return success/fail.
     * - Repository may be tested by the integration test of subunit and repository.
     *   Though, would only test simple operations just to ensure its integration
     *   and not duplicating tests.
     */
    @Test
    fun testSubunits() = runTest {
        val mockRepo = object : PlayerRepository {
            override suspend fun getHealth(playerId: PlayerId) = Result.success(10)
            override suspend fun getItems(playerId: PlayerId) = Result.success(listOf("s3", "s4"))
            override suspend fun updateHealth(playerId: PlayerId, newHealth: Int) = Result.success(Unit)
            override suspend fun updateItems(playerId: PlayerId, newItems: List<String>) = TODO()
        }

        val subunit = PlayerSubunit(mockRepo).also { it.debut(PlayerScope("pid123")) }

        // ex. get methods work correctly (in complex scenario, this may involve processing)
        assertEquals(10, subunit.getHealth())

        // ex. updating should work, and subunit own's data is also updated
        val outcome = subunit.reduceHealth(2)
        assert(outcome.isOk())
        assertEquals(8, outcome.okOrNull())
        assertEquals(8, subunit.getHealth())
    }

    /**
     * Integration test which require real mongo.
     */
    @Test
    fun testSubunitIntegration() = runTest {
        val db = initMongo()

        // reset collection
        val collection = db.getCollection<PlayerModel>("ex_subunit_col")
        collection.drop()
        db.createCollection("ex_subunit_col")

        // insert base data
        val baseData = PlayerModel(
            playerId = "pid123",
            health = 42,
            items = listOf("a", "b", "c")
        )
        collection.insertOne(baseData)

        val repo = MongoPlayerRepository(collection)
        val subunit = PlayerSubunit(repo).also { it.debut(PlayerScope("pid123")) }

        // ex. ensure initialization
        val result = subunit.debut(PlayerScope("pid123"))
        assert(result.isSuccess)

        // ex. ensure get
        assertEquals(42, subunit.getHealth())

        // ex. ensure update
        val outcome = subunit.reduceHealth(10)
        assertTrue(outcome.isOk())

        // ex. ensure DB is updated and match the data in subunit
        val updated = collection.find().first()
        assertEquals(32, updated.health)
        assertEquals(32, outcome.okOrNull())

        collection.drop()
    }
}

/**
 * Example of a domain model
 */
data class PlayerModel(
    val playerId: PlayerId,
    val health: Int,
    val items: List<String>
)

/**
 * Example of a repository handling PlayerModel.
 *
 * Practically though, a repository should handle a single concern (e.g., ItemsRepository)
 * rather than aggregate (unless they are deeply related).
 *
 * All functions are suspend for native coroutine support.
 *
 * Each operation should return a value wrapped in a result type.
 * A `Result<Unit>` can be used when it doesn't have a return type.
 */
interface PlayerRepository {
    suspend fun getHealth(playerId: PlayerId): Result<Int>
    suspend fun getItems(playerId: PlayerId): Result<List<String>>
    suspend fun updateHealth(playerId: PlayerId, newHealth: Int): Result<Unit>
    suspend fun updateItems(playerId: PlayerId, newItems: List<String>): Result<Unit>
}

/**
 * Example of a repository implementation using MongoDB.
 *
 * **Note: Example here tries to introduces strictness. Actual code may slightly lower
 * rigority when necessary.**
 *
 * ### Constructor
 *
 * MongoDB operations work through `MongoCollection`, therefore the initialization
 * of this repository would depend on `MongoClient` or `MongoDatabase`.
 *
 * ### Exception Handling in Operations
 *
 * Typically, operation is wrapped with [runMongoCatching], allowing
 * any errors to be caught and wrapped into the `Result` type.
 *
 * Typically, the result of update, replace, and delete operations are
 * checked to ensure a modification was done. Helper such as [throwIfNothingModified]
 * can be used easily check the result and throw an error.
 *
 * ### Exception Logging
 *
 * No logging should be done in the repository layer, though repository
 * may attach context by passing a string message into `runMongoCatching`.
 *
 * Error that happens in the repository layer is usually Mongo's internal
 * or when the document doesn't exist (which already have a default error message).
 * This makes custom message rarely used.
 *
 * Error would be propagated to the subunit layer where detailed domain
 * logging should be done. This makes error shows up like:
 * - Suppose that the `items` for playerABC does not exist.
 * - By using `runMongoCatching`, getting a `null` data will throw [DocumentNotFoundException]
 *   which has a default message of "Expected document not exist".
 * - The exception will be wrapped in a [Result.failure].
 * - The result is passed to the subunit layer.
 * - Subunit checks whether the result fails and handles accordingly.
 * - It may log something like "Items not found for playerABC".
 *
 * This results in clear separation and no duplicate error logging.
 */
class MongoPlayerRepository(val data: MongoCollection<PlayerModel>) : PlayerRepository {
    override suspend fun getHealth(playerId: PlayerId): Result<Int> {
        return runMongoCatching {
            val filter = Filters.eq(FieldPlayerId, playerId)
            data.find(filter)
                .firstOrNull()
                ?.health
        }
    }

    override suspend fun getItems(playerId: PlayerId): Result<List<String>> {
        return runMongoCatching {
            val filter = Filters.eq(FieldPlayerId, playerId)
            data.find(filter)
                .firstOrNull()
                ?.items
        }
    }

    override suspend fun updateHealth(playerId: PlayerId, newHealth: Int): Result<Unit> {
        return runMongoCatching {
            val filter = Filters.eq(FieldPlayerId, playerId)
            val update = Updates.set("health", newHealth)

            data.updateOne(filter, update)
                .throwIfNothingMatched(playerId, { filter })
        }
    }

    override suspend fun updateItems(playerId: PlayerId, newItems: List<String>): Result<Unit> {
        return runMongoCatching {
            val filter = Filters.eq(FieldPlayerId, playerId)
            val update = Updates.set("items", newItems)

            data.updateOne(filter, update)
                .throwIfNothingMatched(playerId, { filter })
        }
    }
}

/**
 * Example of a subunit scoped to a player that carries [PlayerRepository].
 * Acts as a domain-level abstraction for higher-level components such as message handlers.
 *
 * **Note: Example here tries to introduces strictness. Actual code may slightly lower
 * rigority when necessary.**
 *
 * ### Local Data & Initialization
 *
 * Data is cached locally to reduce repeated queries to the repository.
 * Update operations modify both the local cache and the repository.
 *
 * All fields are initially `null` or empty collections and are populated in [debut].
 * Initialization failures are logged immediately but do not interrupt the subunit
 * or the player's connection (fail-late).
 *
 * Accessing data that failed to initialize or is missing will fail fast at the usage site.
 * Depending on the context, handlers may require these values to be present or handle
 * their absence gently.
 *
 * Example: [items] is essential for the session. If it fails to load during initialization,
 * the error is logged, but the player's session continues. When [items] is later required,
 * the handler may fail the operation (e.g., by throwing [error] inside the `get` methods
 * or via a `requireNotNull`-style check in handler).
 * In cases where the value is optional, the handler may instead provide a fallback.
 *
 * ### Subunit API
 *
 * The subunit exposes domain-oriented APIs derived from repository operations.
 * These APIs may extend or refine repository data into more meaningful abstractions.
 *
 * Example: the repository provides `getInventory()`, while the subunit may expose
 * higher-level queries such as `getEquipment()` or `getFood()` by filtering the data.
 *
 * ### Return Types
 *
 * In a strict handling requirement, subunit's operations may:
 * - Use [encore.utils.types.Report] type for operations that returns `Unit`.
 * - Use [encore.utils.types.Outcome] type for operations that returns a value.
 *
 * Since initialization is fail-late and fields may remain null, all `get` operations
 * are made to return non-null value by throwing [error]; unless when null values are acceptable.
 *
 * ### Logging
 *
 * The subunit is responsible for logging operations in domain language, avoiding
 * DB/repository details.
 *
 * This includes logging any errors on [Result] type obtained from the repository.
 * Typically, the result is chained with [onSuccess] and [onFailure]
 * for logging handler, then converting with [toReport] or [toOutcome] for the return value.
 * Inside `onFailure`, the throwable can call helpers like [failHandleGet] and [failHandleUpdate].
 * Both fail handle helpers has a default message that can be used to avoid writing logging
 * boilerplate, in the case where context is clear enough.
 *
 * It should also avoid logging request context as it is handler's responsibility.
 *
 * For instance:
 * - Repository do not log, but may provide message in exception such as "Document not found"
 * - Subunit logs domain, such as "Couldn't calculate resource with invalid timer object"
 * - Handler logs request context and orchestration, such as
 *   "Failed to collect resource from building=buildingName on calculateResource"
 *
 * ### Handler Example
 *
 * ```
 * // request remain unhandled
 * val items = playerSubunit.getItems().ifEmptyNull ?: return
 *
 * // runtime error thrown by subunit
 * val health = playerSubunit.getHealth()
 *
 * // alternatively, subunit returns nullable value and handler throws
 * val health = requireNotNull(playerSubunit.getHealth()) { "Health is null" }
 *
 * // handling of outcome
 * val health = playerSubunit.getHealth()
 * val response: Response = subunit.getItems().fold(
 *     onOk = { newHp -> ResponseSuccess("HP reduced now: $newHp") },
 *     onFail = {
 *         Fancam.trace { "Failed to reduce HP by $reduceBy, currentHp=$health" }
 *         ResponseFailed("Failed to reduce HP")
 *     }
 * )
 * connection.send(response)
 * ```
 */
class PlayerSubunit(private val playerRepository: PlayerRepository) : Subunit<PlayerScope> {
    private lateinit var playerId: PlayerId
    private var health: Int? = null
    private var items = mutableListOf<String>()

    // must not be null
    fun getHealth(): Int = health ?: error("Health is null")

    // empty acceptable
    fun getItems(): List<String> = items

    // returns Outcome, cares whether the operation succeed or fails, but also need value
    suspend fun reduceHealth(reduceBy: Int): Outcome<Int> {
        val newHealth = getHealth() - reduceBy
        val result = playerRepository.updateHealth(playerId, newHealth)

        return result
            .onSuccess {
                this.health = newHealth
                Fancam.trace { "OK reduceHealth health now=$newHealth" }
            }
            .onFailure {
                it.failHandleUpdate(
                    notFoundMessage = { "Health reduce failed: not found" },
                    notUpdatedMessage = { "Health reduce failed: no document affected" },
                    unknownMessage = { "Unknown error while reducing health" }
                )
            }
            .toOutcome { newHealth }
    }

    // returns Report, only cares whether the operation succeed or fails
    suspend fun updateAllItems(newItems: List<String>): Report {
        val result = playerRepository.updateItems(playerId, newItems)

        return result
            .onSuccess {
                this.items.clear()
                this.items.addAll(newItems)
                Fancam.trace { "OK updateAllItems to ${newItems.joinToString()}" }
            }
            .onFailure { it.failHandleUpdate() }
            .toReport()
    }

    override suspend fun debut(scope: PlayerScope): Result<Unit> {
        return runCatching {
            this.playerId = scope.playerId
            playerRepository.getHealth(scope.playerId)
                .onSuccess { this.health = it }
                .onFailure { it.failHandleGet() }
            playerRepository.getItems(scope.playerId)
                .onSuccess { this.items.addAll(it) }
                .onFailure { it.failHandleGet() }
        }
    }

    override suspend fun disband(scope: PlayerScope): Result<Unit> = Result.success(Unit)
}
