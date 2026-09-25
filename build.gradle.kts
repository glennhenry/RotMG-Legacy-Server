import com.github.jengelman.gradle.plugins.shadow.tasks.ShadowJar
import org.gradle.kotlin.dsl.withType

plugins {
    alias(libs.plugins.kotlin.jvm)
    alias(libs.plugins.ktor)
    alias(libs.plugins.kotlin.plugin.serialization)
}

group = "dev.encore"
version = "1.1.3"

application {
    mainClass = "ApplicationKt"
}

ktor {
    fatJar {
        archiveFileName.set("encore.jar")
    }
}

tasks.withType<ShadowJar> {
    archiveFileName.set("encore.jar")
    destinationDirectory.set(file("deploy"))
    manifest {
        attributes["Main-Class"] = "ApplicationKt"
    }
}

val copyGameAssets = tasks.register<Copy>("copyGameAssets") {
    from("assets")
    into("deploy/assets")
}

val copyBackstageAssets = tasks.register<Copy>("copyBackstageAssets") {
    from("backstage")
    into("deploy/backstage")
}

val copyVenue = tasks.register<Copy>("copyVenue") {
    from("venue.xml")
    into("deploy")
}

val copyVenueSecret = tasks.register<Copy>("copyVenueSecret") {
    from("venue.secret.xml")
    into("deploy")
}

tasks.shadowJar {
    finalizedBy(copyBackstageAssets)
    finalizedBy(copyGameAssets)
    finalizedBy(copyVenue)
    finalizedBy(copyVenueSecret)
}

tasks.named<JavaExec>("run") {
    jvmArgs(
        "--sun-misc-unsafe-memory-access=allow",
        "--enable-native-access=ALL-UNNAMED"
    )
}

tasks.test {
    testLogging {
        showStandardStreams = true
    }
}

tasks.run {
    standardInput = System.`in`
}

dependencies {
    // Ktor core
    implementation(libs.ktor.server.core)
    implementation(libs.ktor.server.netty)
    implementation(libs.ktor.server.cors)
    implementation(libs.ktor.server.status.pages)
    implementation(libs.ktor.server.websockets)
    implementation(libs.ktor.server.double.receive)
    implementation(libs.logger.noop)

    // Ktor serialization
    implementation(libs.ktor.server.content.negotiation)
    implementation(libs.ktor.serialization.kotlinx.json)
    implementation(libs.ktor.serialization.kotlinx.protobuf)

    // Security
    implementation(libs.library.bcrypt)

    // Database
    implementation(libs.mongodb.driver.kotlin.coroutine)
    implementation(libs.mongodb.bson.kotlinx)

    // Tests
    testImplementation(libs.kotlin.test.junit)
    testImplementation(libs.ktor.server.test.host)
}
