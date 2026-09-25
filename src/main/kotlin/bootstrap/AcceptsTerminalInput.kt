package bootstrap

import encore.time.TimeCenter
import encore.utils.identifier.Ids
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.isActive
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.util.concurrent.ConcurrentHashMap
import kotlin.collections.component1
import kotlin.collections.component2
import kotlin.collections.set
import kotlin.time.Duration.Companion.minutes

/**
 * Launches a non-blocking coroutine which reads terminal input.
 *
 * This is specifically made to accepts `token` input to produce a backstage token.
 */
fun acceptsTerminalInput(appScope: CoroutineScope, backstageToken: ConcurrentHashMap<String, Long>) {
    appScope.launch(Dispatchers.IO) {
        while (isActive) {
            val cmd = withContext(Dispatchers.IO) { readlnOrNull() } ?: break
            val clean = cmd.trim().lowercase()
            if (clean.isNotBlank()) {
                when (clean) {
                    "token" -> {
                        val token = Ids.uuid()
                        println(token)
                        backstageToken[token] = TimeCenter.now()
                        val toRemove = mutableListOf<String>()
                        backstageToken.forEach { (token, millis) ->
                            if (TimeCenter.hasElapsedBy(millis, 1.minutes)) {
                                toRemove.add(token)
                            }
                        }
                        toRemove.forEach {
                            backstageToken.remove(it)
                        }
                    }

                    else -> {}
                }
            }
        }
    }
}
