@file:Suppress("ConstPropertyName", "unused")

package encore

import encore.fancam.Fancam
import encore.fancam.events.Level
import encore.utils.Emoji
import game.GameIdentity
import java.time.LocalDate
import java.time.Month
import java.time.MonthDay

/**
 * Defines identity of the Encore framework.
 *
 * Provides a mainly cosmetic, code-level details
 * such as product name, version, slogan, and logo.
 *
 * This information is optional and used only for presentation,
 * for example in server startup banners or log messages.
 *
 * Though, the version can be modified when the framework receives update,
 * ensuring noticeable difference on the server implementation.
 */
object EncoreIdentity {
    const val Title = "Encore"
    const val Version = "1.1.3"
    const val VersionDate = "2026.09.24"
    const val Codename = "Rookie"
    const val Slogan = "Bring it back live."
    const val Logo = """
  _____ _   _  ____ ___  ____  _____ 
 | ____| \ | |/ ___/ _ \|  _ \| ____|
 |  _| |  \| | |  | | | | |_) |  _|  
 | |___| |\  | |__| |_| |  _ <| |___ 
 |_____|_| \_|\____\___/|_| \_\_____|
"""

    fun banner(gameTitle: String, gameVersion: String, gameDescription: String): String {
        return bannerText(gameTitle, gameVersion, gameDescription)
    }

    fun banner(gameIdentity: GameIdentity): String {
        return bannerText(gameIdentity.Title, gameIdentity.Version, gameIdentity.Description)
    }

    private fun bannerText(gameTitle: String, gameVersion: String, gameDescription: String): String {
        val t = gameTitle.ifBlank { "Unnamed" }
        val v = gameVersion.ifBlank { "N/A" }

        return buildString {
            appendLine("_______________________________________________")
            appendLine(Logo.trim('\n'))
            appendLine("-----------------------------------------------")
            appendLine("Era    : $Version at $VersionDate ($Codename)")
            appendLine("Stage  : $t ($v)")
            appendLine("         $gameDescription")
            if (gameDescription.isNotBlank()) {
                appendLine()
            }
            appendLine("Made possible by $Title. $Slogan")
            appendLine("_______________________________________________")
        }
    }

    fun celebrate(today: LocalDate) {
        isSpecialDay(today)
    }

    private fun isSpecialDay(today: LocalDate) {
        when {
            isDate(today, MonthDay.of(Month.MARCH, 2)) -> {
                Fancam.event(Level.Off, "kp")
                    .message { birthdayText("03.02", "Kim Dayeon") }
                    .log()
            }

            isDate(today, MonthDay.of(Month.MARCH, 12)) -> {
                Fancam.event(Level.Off, "kp")
                    .message { birthdayText("03.12", "Ezaki Hikaru") }
                    .log()
            }

            isDate(today, MonthDay.of(Month.APRIL, 26)) -> {
                Fancam.event(Level.Off, "kp")
                    .message { birthdayText("04.26", "Kim Chaehyun") }
                    .log()
            }

            isDate(today, MonthDay.of(Month.JULY, 27)) -> {
                Fancam.event(Level.Off, "kp")
                    .message { birthdayText("07.27", "Huening Bahiyyih") }
                    .log()
            }

            isDate(today, MonthDay.of(Month.AUGUST, 12)) -> {
                Fancam.event(Level.Off, "kp")
                    .message { birthdayText("08.12", "Choi Yujin") }
                    .log()
            }

            isDate(today, MonthDay.of(Month.AUGUST, 22)) -> {
                Fancam.event(Level.Off, "kp")
                    .message { birthdayText("08.22", "Kang Yeseo") }
                    .log()
            }

            isDate(today, MonthDay.of(Month.NOVEMBER, 12)) -> {
                Fancam.event(Level.Off, "kp")
                    .message { birthdayText("11.12", "Shen Xiaoting") }
                    .log()
            }

            isDate(today, MonthDay.of(Month.DECEMBER, 16)) -> {
                Fancam.event(Level.Off, "kp")
                    .message { birthdayText("12.16", "Sakamoto Mashiro") }
                    .log()
            }

            isDate(today, MonthDay.of(Month.DECEMBER, 27)) -> {
                Fancam.event(Level.Off, "kp")
                    .message { birthdayText("12.27", "Seo Youngeun") }
                    .log()
            }
        }
    }

    private fun isDate(today: LocalDate, monthDay: MonthDay): Boolean {
        return today.month == monthDay.month && today.dayOfMonth == monthDay.dayOfMonth
    }

    private fun birthdayText(date: String, name: String): String {
        return "($date) Happy birthday $name... ${Emoji.Birthday}"
    }
}
