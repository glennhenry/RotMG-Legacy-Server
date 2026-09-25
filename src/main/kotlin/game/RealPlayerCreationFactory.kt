package game

import encore.creation.PlayerCreationFactory
import encore.account.model.Profile
import encore.time.TimeCenter
import encore.utils.hash
import encore.utils.identifier.Ids
import encore.utils.types.Report
import game.mongo.collection.PlayerAccount
import game.mongo.collection.PlayerId
import game.mongo.collection.PlayerObjects
import game.mongo.collection.PlayerServerObjects

/**
 * Concrete implementation of [PlayerCreationFactory] that must be
 * updated overtime. Add server object repositories as dependency if needed.
 */
class RealPlayerCreationFactory : PlayerCreationFactory {
    override fun playerId(isAdmin: Boolean): PlayerId {
        if (isAdmin) return Globals.ADMIN_PLAYER_ID
        return Ids.uuid()
    }

    override fun account(
        playerId: PlayerId,
        username: String,
        password: String,
        email: String
    ): PlayerAccount {
        val now = TimeCenter.now()
        val account = PlayerAccount(
            playerId = playerId,
            username = username,
            email = email,
            hashedPassword = hash(password),
            profile = Profile(
                playerId = playerId,
                createdAt = now,
                lastActiveAt = now
            ),
        )
        return account
    }


    override fun playerObjects(playerId: PlayerId): PlayerObjects {
        return if (playerId == Globals.ADMIN_PLAYER_ID) {
            PlayerObjects.admin()
        } else {
            PlayerObjects.newGame(playerId)
        }
    }

    override fun playerServerObjects(playerId: PlayerId): PlayerServerObjects {
        return if (playerId == Globals.ADMIN_PLAYER_ID) {
            PlayerServerObjects.admin()
        } else {
            PlayerServerObjects.newGame(playerId)
        }
    }

    override fun updateServerObjects(
        account: PlayerAccount,
        objects: PlayerObjects
    ): Report {
        // update server objects if needed...
        return Report.Ok
    }
}
