package encore.creation

import encore.utils.types.Report
import game.mongo.collection.PlayerAccount
import game.mongo.collection.PlayerId
import game.mongo.collection.PlayerObjects
import game.mongo.collection.PlayerServerObjects

class BlankPlayerCreationFactory: PlayerCreationFactory {
    override fun playerId(isAdmin: Boolean): PlayerId {
        TODO("Not yet implemented")
    }

    override fun account(
        playerId: PlayerId,
        username: String,
        password: String,
        email: String
    ): PlayerAccount {
        TODO("Not yet implemented")
    }

    override fun playerObjects(playerId: PlayerId): PlayerObjects {
        TODO("Not yet implemented")
    }

    override fun playerServerObjects(playerId: PlayerId): PlayerServerObjects {
        TODO("Not yet implemented")
    }

    override fun updateServerObjects(
        account: PlayerAccount,
        objects: PlayerObjects
    ): Report {
        TODO("Not yet implemented")
    }
}
