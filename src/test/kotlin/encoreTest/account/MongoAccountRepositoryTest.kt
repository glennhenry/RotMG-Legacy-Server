package encoreTest.account

import TestMongoCollections
import encore.account.MongoAccountRepository
import encore.account.model.Credentials
import encore.account.model.Profile
import game.mongo.collection.PlayerAccount
import encore.utils.identifier.Ids
import encore.utils.hash
import initMongo
import kotlinx.coroutines.test.runTest
import testUtils.*
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertTrue

/**
 * Test operations of [MongoAccountRepository].
 */
class MongoAccountRepositoryTest {
    @Test
    fun `test all`() = runTest {
        val mongoDb = initMongo()
        val collection = mongoDb.getCollection<PlayerAccount>(TestMongoCollections.playerAccount)
        collection.drop()
        mongoDb.createCollection(TestMongoCollections.playerAccount)

        val repo = MongoAccountRepository(collection)

        val id = "id123"
        val name = "name123"
        val email = "name@email.com"
        val account = PlayerAccount(
            id,
            name,
            email,
            hash("pw123"),
            createProfile("id123"),
        )

        collection.insertMany(List(20) { account() } + account)

        assertEquals(account.playerId, repo.getAccountByPlayerId(id).getOrThrow().playerId)
        assertEquals(account.playerId, repo.getAccountByUsername(name).getOrThrow().playerId)
        assertEquals(id, repo.getPlayerIdByUsername(name).getOrThrow())
        assertEquals(Credentials(id, account.hashedPassword), repo.getCredentials(name).getOrThrow())

        val newId = "id321"

        repo.updatePlayerAccount(
            id, account.copy(
                playerId = newId,
                profile = account.profile.copy(playerId = newId)
            )
        )
        val a = repo.getAccountByUsername(name).getOrThrow()
        assertEquals(newId, a.playerId)
        assertEquals(newId, a.profile.playerId)

        repo.updateLastActivity(newId, 1000)
        assertEquals(1000, repo.getAccountByUsername(name).getOrThrow().profile.lastActiveAt)

        repo.updateProfile(newId, Profile(newId, createdAt = 1234, lastActiveAt = 5678))
        val pr = repo.getAccountByUsername(name).getOrThrow().profile
        assertEquals(1234, pr.createdAt)
        assertEquals(5678, pr.lastActiveAt)

        assertTrue(repo.usernameExists(name).getOrThrow())
        assertTrue(repo.emailExists(email).getOrThrow())
    }

    private fun account(): PlayerAccount {
        return createAccount(Ids.uuid(), randstr(), randstr())
    }

    private val charpool = ('a'..'z').toList()
    private fun randstr(): String {
        return randomString(8, charpool)
    }
}
