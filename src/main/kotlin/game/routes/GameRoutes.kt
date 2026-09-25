package game.routes

import encore.fancam.Fancam
import encore.route.RouteHandler
import encore.route.guard.NoAuthGuard
import encore.route.handle
import game.routes.utils.formBodyToMap
import io.ktor.http.HttpStatusCode
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import java.io.File

class GameRoutes : RouteHandler {
    override fun Route.install() {
        post("/app/getLanguageStrings") {
            handle(call, NoAuthGuard) {
                val payload = call.receiveText().formBodyToMap()
                Fancam.debug { "Request to getLanguageStrings: $payload" }
                call.respondFile(File("assets/game/strings.json"))
            }
        }
        post("/app/init") {
            handle(call, NoAuthGuard) {
                val payload = call.receiveText().formBodyToMap()
                Fancam.debug { "Request to init: $payload" }
                call.respondFile(File("assets/game/init.xml"))
            }
        }
        post("/char/list") {
            handle(call, NoAuthGuard) {
                val payload = call.receiveText().formBodyToMap()
                Fancam.debug { "Request to char/list: $payload" }
                call.respond(HttpStatusCode.OK, charlistResponse)
            }
        }
        post("/package/getPackages") {
            handle(call, NoAuthGuard) {
                val payload = call.receiveText().formBodyToMap()
                Fancam.debug { "Request to package/getPackages: $payload" }
                call.respond(HttpStatusCode.OK, EmptyPackageResponse)
            }
        }
    }
}

const val EmptyPackageResponse = "<Packages></Packages>"

val charlistResponse = """
<chars nextCharId="1" maxNumChars="3">
    <Account>
        <AccountId>-1</AccountId>
        <Name>Chaehyun</Name>
        <Admin />
        <Stats>
            <TotalFame>4000</TotalFame>
            <Fame>200</Fame>
            <ClassStats objectType="307">
                <BestLevel>20</BestLevel>
                <BestFame>201</BestFame>
            </ClassStats>
        </Stats>
        <Credits>121</Credits>
        <FortuneToken>122</FortuneToken>
        <NextCharSlotPrice>123</NextCharSlotPrice>
        <IsAgeVerified>1</IsAgeVerified>
        <VerifiedEmail />
        <BeginnerPackageTimeLeft>600600</BeginnerPackageTimeLeft>
        <PetYardType>5</PetYardType>
    </Account>
    <Pet instanceId="1" type="32620" name="Rahmat" rarity="4">
        <Abilities>
            <Ability type="356" power="100" points="0"></Ability>
            <Ability type="368" power="100" points="0"></Ability>
            <Ability type="386" power="98" points="2020"></Ability>
        </Abilities>
    </Pet>
    <Char>
        <Pet instanceId="1" type="32620" name="Rahmat" rarity="4">
            <Abilities>
                <Ability type="356" power="100" points="0"></Ability>
                <Ability type="368" power="100" points="0"></Ability>
                <Ability type="386" power="98" points="2020"></Ability>
            </Abilities>
        </Pet>
    </Char>
    <Servers>
        <Server>
            <Name>Asia</Name>
            <dns>127.0.0.1:8080</dns>
            <Lat>37.34</Lat>
            <Long>-121.89</Long>
            <Usage>0.00</Usage>
        </Server>
    </Servers>
    <MaxClassLevelList>
        <MaxClassLevel classType="307" maxLevel="20" />
    </MaxClassLevelList>
    <ClassAvailabilityList>
        <ClassAvailability id="Rogue">available</ClassAvailability>
        <ClassAvailability id="Assassin">available</ClassAvailability>
        <ClassAvailability id="Huntress">available</ClassAvailability>
        <ClassAvailability id="Mystic">available</ClassAvailability>
        <ClassAvailability id="Trickster">available</ClassAvailability>
        <ClassAvailability id="Sorcerer">available</ClassAvailability>
        <ClassAvailability id="Ninja">unavailable</ClassAvailability>
        <ClassAvailability id="Archer">available</ClassAvailability>
        <ClassAvailability id="Wizard">available</ClassAvailability>
        <ClassAvailability id="Priest">available</ClassAvailability>
        <ClassAvailability id="Necromancer">available</ClassAvailability>
        <ClassAvailability id="Warrior">available</ClassAvailability>
        <ClassAvailability id="Knight">available</ClassAvailability>
        <ClassAvailability id="Paladin">available</ClassAvailability>
    </ClassAvailabilityList>
    <ItemCosts>
        <ItemCost type="900" purchasable="0" expires="0">90000</ItemCost>
        <ItemCost type="902" purchasable="0" expires="0">90000</ItemCost>
        <ItemCost type="834" purchasable="1" expires="0">900</ItemCost>
        <ItemCost type="835" purchasable="1" expires="0">600</ItemCost>
        <ItemCost type="836" purchasable="1" expires="0">900</ItemCost>
        <ItemCost type="837" purchasable="1" expires="0">600</ItemCost>
        <ItemCost type="838" purchasable="1" expires="0">900</ItemCost>
        <ItemCost type="839" purchasable="1" expires="0">900</ItemCost>
        <ItemCost type="840" purchasable="1" expires="0">900</ItemCost>
        <ItemCost type="841" purchasable="1" expires="0">900</ItemCost>
        <ItemCost type="842" purchasable="1" expires="0">900</ItemCost>
        <ItemCost type="843" purchasable="1" expires="0">900</ItemCost>
        <ItemCost type="844" purchasable="1" expires="0">900</ItemCost>
        <ItemCost type="845" purchasable="1" expires="0">900</ItemCost>
        <ItemCost type="846" purchasable="1" expires="0">900</ItemCost>
        <ItemCost type="847" purchasable="1" expires="0">900</ItemCost>
        <ItemCost type="848" purchasable="1" expires="0">900</ItemCost>
        <ItemCost type="849" purchasable="1" expires="0">900</ItemCost>
        <ItemCost type="850" purchasable="0" expires="1">900</ItemCost>
        <ItemCost type="851" purchasable="0" expires="1">900</ItemCost>
        <ItemCost type="852" purchasable="1" expires="0">900</ItemCost>
        <ItemCost type="853" purchasable="1" expires="0">900</ItemCost>
        <ItemCost type="854" purchasable="1" expires="0">900</ItemCost>
        <ItemCost type="855" purchasable="1" expires="0">900</ItemCost>
        <ItemCost type="856" purchasable="0" expires="0">90000</ItemCost>
        <ItemCost type="883" purchasable="0" expires="0">90000</ItemCost>
        <ItemCost type="1026" purchasable="1" expires="0">0</ItemCost>
    </ItemCosts>
    <OwnedSkins>800,801,856</OwnedSkins>
    <News></News>
</chars>
""".trimIndent()
// guild
// news
// lat long
// SalesForce
// TOSpopup
