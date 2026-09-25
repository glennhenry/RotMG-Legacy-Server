package encore.extra

import encore.fancam.Fancam
import encore.fancam.Tags
import encore.subunit.Subunit
import encore.subunit.scope.ServerScope
import encore.utils.types.Outcome
import encore.utils.types.Report
import encore.utils.types.toOutcome
import encore.utils.types.toReport
import game.mongo.collection.PlayerId

/**
 * Server subunit for [PlayerExtraRepository].
 */
class PlayerExtraSubunit(
    private val extraRepository: PlayerExtraRepository
) : Subunit<ServerScope> {
    suspend fun getExtra(playerId: PlayerId, key: String): Outcome<String?> {
        return extraRepository.getExtra(playerId, key)
            .onFailure {
                Fancam.error(it, Tags.Extra) {
                    "getExtra failed: repository scandal for '$playerId' on key=$key"
                }
            }
            .toOutcome { ext -> return Outcome.Ok(ext) }
    }

    suspend fun getAllExtra(playerId: PlayerId, key: String): Outcome<Map<String, String>?> {
        return extraRepository.getAllExtra(playerId, key)
            .onFailure {
                Fancam.error(it, Tags.Extra) {
                    "getAllExtra failed: repository scandal for '$playerId' on key=$key"
                }
            }
            .toOutcome { ext -> return Outcome.Ok(ext) }
    }

    suspend fun updateExtra(playerId: PlayerId, key: String, value: String): Report {
        return extraRepository.updateExtra(playerId, key, value)
            .onFailure {
                Fancam.error(it, Tags.Extra) {
                    "updateExtra failed: repository scandal for '$playerId' on key=$key to value=$value"
                }
            }
            .toReport()
    }

    suspend fun deleteExtra(playerId: PlayerId, key: String): Report {
        return extraRepository.deleteExtra(playerId, key)
            .onFailure {
                Fancam.error(it, Tags.Extra) {
                    "deleteExtra failed: repository scandal for '$playerId' on key=$key"
                }
            }
            .toReport()
    }

    override suspend fun debut(scope: ServerScope): Result<Unit> {
        return runCatching { }
    }

    override suspend fun disband(scope: ServerScope): Result<Unit> {
        return runCatching { }
    }

    companion object {
        fun createForTest(extraRepository: PlayerExtraRepository): PlayerExtraSubunit {
            return PlayerExtraSubunit(extraRepository)
        }
    }
}
