package encoreTest.extra

import TestMongoCollections
import encore.extra.MongoPlayerExtraRepository
import game.mongo.collection.PlayerServerObjects
import initMongo
import kotlinx.coroutines.test.runTest
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertNotNull

class MongoPlayerExtraRepositoryTest {
    @Test
    fun `test all`() = runTest {
        val mongoDb = initMongo()
        val collection = mongoDb.getCollection<PlayerServerObjects>(TestMongoCollections.playerServerObjects)
        collection.drop()
        mongoDb.createCollection(TestMongoCollections.playerServerObjects)

        collection.insertOne(
            PlayerServerObjects(
                playerId = "abc", extra = mapOf("a" to "123", "b" to "456")
            )
        )

        val repo = MongoPlayerExtraRepository(collection)

        // 1. getExtra
        assertEquals("123", repo.getExtra("abc", key = "a").getOrNull())

        // 2. updateExtra
        assertNotNull(repo.updateExtra("abc", key = "a", value = "444"))
        assertEquals("444", repo.getExtra("abc", key = "a").getOrNull())

        // 3. deleteExtra
        assertNotNull(repo.deleteExtra("abc", "a").getOrNull())
        assertEquals(null, repo.getExtra("abc", key = "a").getOrNull())
    }
}
