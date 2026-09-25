package encoreTest

import bootstrap.errorHtml

/**
 * Untested things on server (mostly on routing).
 * These are typically lazy and annoying to tests while producing little value and rarely change.
 *
 * --core routing--
 * 1. Unhandled API/routes returns an [errorHtml].
 * 2. Unhandled exception returns internal server error (500) with error trace in development mode.
 * 3. Unhandled exception returns internal server error (500) with flavour text in non-development mode.
 * 4. RouteHandler.handle or guard works with the given AuthGuard mechanism.
 * --security--
 * 5. configureSecurity works with the given SecurityGuard mechanism.
 *        example:
 *          - DefaultSecurity on content length
 *          - DefaultSecurity on banned address
 *          - DefaultSecurity on rate limit
 *        each would return an [errorHtml].
 * --docs routing--
 * 6. In deployment mode, /docs return docs website.
 * 7. In non-deployment mode, /docs return 404.
 * --backstage--
 * 8. In development mode, /backstage bypass auth and return main.html
 * 9. In non-development mode, /backstage return wall.html
 * 10. /backstage login with token succeed
 * 11. /backstage login with cookie succeed
 * 12. /backstage login with cookie failed when expired (6 hours)
 * --backstage websocket--
 * 13. In non/development mode, /backstage websocket connects to logger, monitor, command
 * 14. /backstage logger, monitor, command work as expected
 */
