package game.socket

import encore.venue.Venue
import java.security.KeyFactory
import java.security.spec.PKCS8EncodedKeySpec
import javax.crypto.Cipher
import kotlin.io.encoding.Base64

object RSAUtils {
    private val privateKey = KeyFactory.getInstance("RSA").generatePrivate(
        PKCS8EncodedKeySpec(
            Base64.decode(
                Venue.secret.privateRSAKey
                    .replace("-----BEGIN PRIVATE KEY-----", "")
                    .replace("-----END PRIVATE KEY-----", "")
                    .replace("\\s".toRegex(), "")
            )
        )
    )

    private val cipher = Cipher.getInstance("RSA/ECB/PKCS1Padding").also {
        it.init(Cipher.DECRYPT_MODE, privateKey)
    }

    /**
     * Decrypt an encrypted RSA string in Base64 format into a UTF-8 String.
     */
    fun decrypt(base64String: String): String {
        val encrypted = Base64.decode(base64String)
        val decryptedBytes = cipher.doFinal(encrypted)
        return String(decryptedBytes, Charsets.UTF_8)
    }
}
