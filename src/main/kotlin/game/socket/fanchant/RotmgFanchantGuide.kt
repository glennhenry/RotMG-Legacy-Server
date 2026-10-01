package game.socket.fanchant

import encore.network.fanchant.Fanchant
import encore.network.fanchant.guide.DecodeResult
import encore.network.fanchant.guide.FanchantGuide
import game.domain.auth.HelloFanchant
import game.domain.character.CreateFanchant
import game.domain.world.movement.GotoAckFanchant
import game.domain.world.status.LoadFanchant
import game.domain.world.movement.MoveFanchant
import game.domain.world.gameplay.PlayerShootFanchant
import game.domain.world.status.UpdateAckFanchant
import game.domain.world.gameplay.EnemyHitFanchant
import game.domain.world.gameplay.ShootAckFanchant
import game.socket.RotmgMessageIds
import java.io.DataInputStream

/**
 * [FanchantGuide] implementation for Rotmg messages.
 * - [verify] always returns `true`.
 * - [tryDecode] simply unwraps the message into a `messageId` and data section.
 * - [materialize] list every recognized fanchant and distribute it based on `messageId`.
 *   See [game.socket.RotmgMessageIds] for a full list.
 */
class RotmgFancantGuide : FanchantGuide<Pair<Int, ByteArray>> {
    override fun verify(data: ByteArray): Boolean {
        return true
    }

    override fun tryDecode(data: ByteArray): DecodeResult<Pair<Int, ByteArray>> {
        val input = DataInputStream(data.inputStream())

        val totalPayloadLength = input.readInt()
        val messageLength = totalPayloadLength - 5

        val messageId = input.readByte().toInt()
        val data = input.readNBytes(messageLength)

        return DecodeResult.Success(messageId to data)
    }

    override fun materialize(decoded: Pair<Int, ByteArray>): Fanchant {
        val (messageId, bytes) = decoded

        // add more message entries here...
        val fanchantClass: RotmgFanchant = when (messageId) {
            RotmgMessageIds.HELLO -> HelloFanchant()
            RotmgMessageIds.GOTOACK -> GotoAckFanchant()
            RotmgMessageIds.CREATE -> CreateFanchant()
            RotmgMessageIds.LOAD -> LoadFanchant()
            RotmgMessageIds.UPDATEACK -> UpdateAckFanchant()
            RotmgMessageIds.MOVE -> MoveFanchant()
            RotmgMessageIds.PLAYERSHOOT -> PlayerShootFanchant()
            RotmgMessageIds.ENEMYHIT -> EnemyHitFanchant()
            RotmgMessageIds.SHOOTACK -> ShootAckFanchant()
            else -> FallbackRotmgFanchant(messageId)
        }
        val input = DataInputStream(bytes.inputStream())
        fanchantClass.readBytes(input)

        return fanchantClass
    }
}
