package testUtils

fun randomString(length: Int, pool: List<Char>): String {
    return buildString(length) {
        repeat(length) { append(pool.random()) }
    }
}
