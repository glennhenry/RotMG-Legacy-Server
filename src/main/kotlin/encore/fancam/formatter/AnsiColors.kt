package encore.fancam.formatter

/**
 * Ansi colors (256) constants to style console.
 *
 * Must use Gradle argument "--console=plain" for color to work consistently.
 */
@Suppress("unused", "ConstPropertyName")
object AnsiColors {
    const val Esc = "\u001B"
    const val Reset = "$Esc[0m"

    const val BlackText = "$Esc[38;5;16m"

    const val TraceFg = "$Esc[38;5;29m"  // #00875F emerald green
    const val DebugFg = "$Esc[38;5;13m"  // #FF00FF fuchsia
    const val InfoFg = "$Esc[38;5;19m"   // #0000AF duke blue
    const val WarnFg = "$Esc[38;5;178m"  // #D7AF00 golden rod
    const val ErrorFg = "$Esc[38;5;196m" // #FF0000 bright red
    const val TagFg = "$Esc[38;5;54m"    // #5F0087 metallic violet

    const val TraceBg = "$Esc[48;5;66m"  // #5F8787 muted teal
    const val DebugBg = "$Esc[48;5;219m" // #FFAFFF bubble gum pink
    const val InfoBg = "$Esc[48;5;153m"  // #AFD7FF sky blue
    const val WarnBg = "$Esc[48;5;221m"  // #FFD75F dandelion
    const val ErrorBg = "$Esc[48;5;203m" // #FF5F5F pastel red
    const val TagBg = "$Esc[48;5;254m"   // #E4E4E4 platinum

    fun fg(n: Int) = "$Esc[38;5;${n}m"
    fun bg(n: Int) = "$Esc[48;5;${n}m"
    fun bold(text: String) = "$Esc[1m$text$Esc[22m"
}

/**
 * Colorize the given [text] with a **256-foreground** [color].
 * This start ANSI coloring, places text, and put a reset afterward.
 */
fun colorizeSegmentFg(color: Int, text: String): String {
    return "${AnsiColors.fg(color)}$text${AnsiColors.Reset}"
}

/**
 * Colorize the given [text] with a **256-background** [color].
 * This start ANSI coloring, places text, and put a reset afterward.
 */
fun colorizeSegmentBg(color: Int, text: String): String {
    return "${AnsiColors.bg(color)}$text${AnsiColors.Reset}"
}
