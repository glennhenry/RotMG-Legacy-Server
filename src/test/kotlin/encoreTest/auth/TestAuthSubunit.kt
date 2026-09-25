package encoreTest.auth

import TestMongoCollections
import encore.account.AccountRepository
import encore.account.AccountSubunit
import encore.account.MongoAccountRepository
import encore.creation.PlayerCreationSubunit
import encore.account.model.Credentials
import encore.account.model.Profile
import encore.auth.AuthSubunit
import encore.auth.LoginResult
import encore.datastore.MongoDataStore
import game.mongo.collection.PlayerAccount
import game.mongo.collection.PlayerId
import encore.session.SessionSubunit
import encore.time.source.SystemTimeSource
import encore.utils.types.Outcome
import encore.utils.types.okOrThrow
import game.RealPlayerCreationFactory
import initMongo
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.test.StandardTestDispatcher
import kotlinx.coroutines.test.TestScope
import kotlinx.coroutines.test.runTest
import testUtils.createProfile
import kotlin.test.Test
import kotlin.test.assertFalse
import kotlin.test.assertNull
import kotlin.test.assertTrue

/**
 * Integration test for [encore.auth.AuthSubunit] and [encore.account.AccountRepository].
 *
 * Ensure MongoDB is running.
 *
 * [encore.auth.AuthSubunit.isUsernameAvailable] has extra logic than [encore.account.AccountRepository.usernameExists]
 * try calling `repo.usernameExists("name").getOrThrow()` in addition to `isUsernameAvailable`.
 */
class TestAuthSubunit {
    private fun scope(): CoroutineScope {
        return TestScope(StandardTestDispatcher())
    }

    @Test
    fun `username shouldn't be available after user is registered`() = runTest {
        val mongoDb = initMongo()
        val collection = mongoDb.getCollection<PlayerAccount>(TestMongoCollections.playerAccount)
        collection.drop()
        mongoDb.createCollection(TestMongoCollections.playerAccount)

        val db = MongoDataStore(mongoDb, TestMongoCollections)
        val manager = SessionSubunit(scope(), SystemTimeSource())
        val repo = MongoAccountRepository(collection)
        val accountSubunit = AccountSubunit(repo)
        val pcs = PlayerCreationSubunit(db, RealPlayerCreationFactory())
        val auth = AuthSubunit(accountSubunit, pcs, manager)

        val account = PlayerAccount(
            playerId = "pid12345",
            username = "name",
            email = "anyemail",
            hashedPassword = "anypassword",
            profile = createProfile("pid12345")
        )
        collection.insertOne(account)

        assertFalse(auth.isUsernameAvailable("name").okOrThrow())
        assertTrue(repo.usernameExists("name").getOrThrow())
    }

    @Test
    fun `username should be available if user is not registered`() = runTest {
        val mongoDb = initMongo()
        val collection = mongoDb.getCollection<PlayerAccount>(TestMongoCollections.playerAccount)
        collection.drop()
        mongoDb.createCollection(TestMongoCollections.playerAccount)

        val db = MongoDataStore(mongoDb, TestMongoCollections)
        val manager = SessionSubunit(scope(), SystemTimeSource())
        val repo = MongoAccountRepository(collection)
        val accountSubunit = AccountSubunit(repo)
        val pcs = PlayerCreationSubunit(db, RealPlayerCreationFactory())
        val auth = AuthSubunit(accountSubunit, pcs, manager)

        assertTrue(auth.isUsernameAvailable("xyz").okOrThrow())
        assertFalse(repo.usernameExists("xyz").getOrThrow())
    }

    @Test
    fun `register should create user`() = runTest {
        val mongoDb = initMongo()
        val collection = mongoDb.getCollection<PlayerAccount>(TestMongoCollections.playerAccount)
        collection.drop()
        mongoDb.createCollection(TestMongoCollections.playerAccount)

        val db = MongoDataStore(mongoDb, TestMongoCollections)
        val manager = SessionSubunit(scope(), SystemTimeSource())
        val repo = MongoAccountRepository(collection)
        val accountSubunit = AccountSubunit(repo)
        val pcs = PlayerCreationSubunit(db, RealPlayerCreationFactory())
        val auth = AuthSubunit(accountSubunit, pcs, manager)

        auth.register("helloworld", "kotlinktor", "helloworld@email.com")
        assertFalse(auth.isUsernameAvailable("helloworld").okOrThrow())
        assertTrue(repo.usernameExists("helloworld").getOrThrow())
    }

    @Test
    fun `register failed because username or email is duplicate`() = runTest {
        val mongoDb = initMongo()
        val collection = mongoDb.getCollection<PlayerAccount>(TestMongoCollections.playerAccount)
        collection.drop()
        mongoDb.createCollection(TestMongoCollections.playerAccount)

        val db = MongoDataStore(mongoDb, TestMongoCollections)
        val manager = SessionSubunit(scope(), SystemTimeSource())
        val repo = MongoAccountRepository(collection)
        val accountSubunit = AccountSubunit(repo)
        val pcs = PlayerCreationSubunit(db, RealPlayerCreationFactory())
        val auth = AuthSubunit(accountSubunit, pcs, manager)

        auth.register("helloworld1", "kotlinktor", "helloworld1@email.com")
        // duplicate username fail
        val res1 = auth.register("helloworld1", "kotlinktor", "helloworld2@email.com")
        assertNull(res1.okOrThrow())

        auth.register("worldhello1", "kotlinktor", "worldhello1@email.com")
        // duplicate email fail
        val res2 = auth.register("worldhello2", "kotlinktor", "worldhello1@email.com")
        assertNull(res2.okOrThrow())
    }

    @Test
    fun `login failures when account don't exist`() = runTest {
        val mongoDb = initMongo()
        val collection = mongoDb.getCollection<PlayerAccount>(TestMongoCollections.playerAccount)
        collection.drop()
        mongoDb.createCollection(TestMongoCollections.playerAccount)

        val db = MongoDataStore(mongoDb, TestMongoCollections)
        val manager = SessionSubunit(scope(), SystemTimeSource())
        val repo = MongoAccountRepository(collection)
        val accountSubunit = AccountSubunit(repo)
        val pcs = PlayerCreationSubunit(db, RealPlayerCreationFactory())
        val auth = AuthSubunit(accountSubunit, pcs, manager)

        val session = auth.login("asdf", "fdsa")
        // Ok = no internal error
        assertTrue((session as Outcome.Ok).value is LoginResult.AccountNotFound)
    }

    @Test
    fun `login failures when credentials are wrong`() = runTest {
        val mongoDb = initMongo()
        val collection = mongoDb.getCollection<PlayerAccount>(TestMongoCollections.playerAccount)
        collection.drop()
        mongoDb.createCollection(TestMongoCollections.playerAccount)

        val db = MongoDataStore(mongoDb, TestMongoCollections)
        val manager = SessionSubunit(scope(), SystemTimeSource())
        val repo = MongoAccountRepository(collection)
        val accountSubunit = AccountSubunit(repo)
        val pcs = PlayerCreationSubunit(db, RealPlayerCreationFactory())
        val auth = AuthSubunit(accountSubunit, pcs, manager)

        auth.register("helloworld", "kotlinktor", "helloworld@email.com")
        val session = auth.login("helloworld", "ktor")
        assertTrue((session as Outcome.Ok).value is LoginResult.InvalidCredentials)
    }

    @Test
    fun `login failures when repository has internal error`() = runTest {
        val mongoDb = initMongo()
        val collection = mongoDb.getCollection<PlayerAccount>(TestMongoCollections.playerAccount)
        collection.drop()
        mongoDb.createCollection(TestMongoCollections.playerAccount)

        val db = MongoDataStore(mongoDb, TestMongoCollections)
        val manager = SessionSubunit(scope(), SystemTimeSource())
        val repo = object : AccountRepository {
            override suspend fun getAccountByPlayerId(playerId: PlayerId): Result<PlayerAccount?> = TODO()
            override suspend fun getAccountByUsername(username: String): Result<PlayerAccount?> = TODO()
            override suspend fun getPlayerIdByUsername(username: String): Result<PlayerId?> = TODO()
            override suspend fun getCredentials(username: String): Result<Credentials?> =
                Result.failure(RuntimeException("xiaoting"))

            override suspend fun getProfile(playerId: PlayerId): Result<Profile?> = TODO()
            override suspend fun updatePlayerAccount(playerId: PlayerId, account: PlayerAccount): Result<Unit> = TODO()
            override suspend fun updateProfile(playerId: PlayerId, profile: Profile): Result<Unit> = TODO()
            override suspend fun updateLastActivity(playerId: PlayerId, lastActivity: Long): Result<Unit> = TODO()
            override suspend fun usernameExists(username: String): Result<Boolean> = TODO()
            override suspend fun emailExists(email: String): Result<Boolean> = TODO()
        }
        val accountSubunit = AccountSubunit(repo)
        val pcs = PlayerCreationSubunit(db, RealPlayerCreationFactory())
        val auth = AuthSubunit(accountSubunit, pcs, manager)

        auth.register("helloworld", "kotlinktor", "helloworld@email.com")
        val session = auth.login("helloworld", "ktor")
        // should error on first call to repository in getCredentials
        assertTrue(session is Outcome.Fail)
    }

    @Test
    fun `login success when user is registered and credentials are correct`() = runTest {
        val mongoDb = initMongo()
        val collection = mongoDb.getCollection<PlayerAccount>(TestMongoCollections.playerAccount)
        collection.drop()
        mongoDb.createCollection(TestMongoCollections.playerAccount)

        val db = MongoDataStore(mongoDb, TestMongoCollections)
        val manager = SessionSubunit(scope(), SystemTimeSource())
        val repo = MongoAccountRepository(collection)
        val accountSubunit = AccountSubunit(repo)
        val pcs = PlayerCreationSubunit(db, RealPlayerCreationFactory())
        val auth = AuthSubunit(accountSubunit, pcs, manager)

        auth.register("helloworld", "kotlinktor", "helloworld@email.com")
        val session = auth.login("helloworld", "kotlinktor")
        assertTrue(((session as Outcome.Ok).value is LoginResult.Success))
    }
}