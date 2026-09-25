# About Encore

Encore is a code template used to prototype an online game private server quickly.

## History

### Private Server Development

The framework originated from a private server development of a dead online game around July 2025.

What I noticed, the development process is very different from learning a tutorial or doing toy projects.

- In a difficult reverse engineering context, we want to minimize the cognitive load on writing the server so we can focus on exploring the game itself. The codebase should be simple, explicit, and maintainable.
- Due to the unfamiliarity of the game, we can't decide the architecture beforehand. The server code usually evolves overtime.
- Learning is difficult and annoying. It's normal to be distracted to the server development, especially if it's about "bringing a game back." Learning a framework, library, or other people solution reduce interests and slows us down. This specific reason contributes a significant part in the framework development.
- Similarly, we want to minimize spending time doing the boring or repetitive things like auth, account system, or database. Since production is not a goal, I implemented them just once and reuse it for future projects. It was implemented as simple as possible from the elementary principles.

<p style="border: 1px solid black; padding: 4px;">
It was pretty much "obsession-driven development," we don't care how bad is the codebase, we just want the game to run. This what makes the development fun, it's unserious, non-formal while also being extremely meaningful. A player wouldn't care if we didn't follow the SOLID principle, but they care when the loading screen progresses by 1%.
</p>

The days to several weeks dealing with the project lets me develop a mental model of private server development loops. Overtime, I get interested into private server development in general, and wanted to try implementing for other games. While doing so, I noticed a heavy copy-pasting on the server code. I don't want to reimplement things I did before. I just clone old projects, delete the implementation part, and reuse the code for new projects. It wasn't smooth as many adaptations, deletions, and changes has to be done.

During reverse engineering context, I always encounter the similar problems and patterns:

- Repetitive things like auth, account, database, etc.
- Needed a flexible way to define database schema, a way to easily load data from the database and transfer to client without friction.
- Debugging what packets are coming from the client and how our responses are being sent.
- A structured way to handle messages.
- Clear abstraction between message handling, domain code, and database.
- Many games have server-sided rules or data. The data are written in format like XML, and we have to parse them and decide what to do during gameplay from that.
- Server-side scheduled tasks for game timer.
- Dependency injection across the whole server including the player runtime state.
- More advanced way to debug server behavior or clear logging display.
- Rapid prototyping and easy to adapt on top of everything.

Overall, many things were repetition of older projects. Most basic components are transferrable, some needs to be adapted. Messaging handling system usually vary the most, typically its architecture depend on the messaging mechanism itself.

At that time, the codebase wasn't a template or framework yet, I simply kep1 refactoring the code while I encounter problems.

### Beginning of the Framework

On Nov 2025, I got the idea of creating a skeleton version of the code. I stripped down the implementation layer of my most advanced project. This results in an "empty game server template." Adapation becomes easier as I only need to rename some identifiers and start implementing the game behavior with the same mental model.

However, updating the template becomes a chore. Whenever something is lacking, I have to modify the template code, and then update every implementations. I didn't want the extra effort managing a library, so I just kep1 doing this manually.

I realize that many things are still missing from the template, and I want an easier way to adapt to new projects. On Feb 2026, I thought of doing a mass refactor and upgrade while making the project "cooler" with the notion of framework.

### Inspiration

Primarily, I was motivated by Chinese MMO private servers. They make a lot of private servers and eventually created their own XAMPP and a one-click install tool for simple self-hosting of the server app and easy distribution. I was also inspired by game keygen softwares and old school online game in general.

- I realized that my case is similar to the Chinese developers. I eventually created my own template to make prototyping faster.
- Old school online game reminds a specific vibes: early internet, forum board, IRC, unique user interface.
- Keygen software is very specific: you want to play a game, but it's paid, so you had to dive over the internet and risk your computer a malware. The musics were memorable, cybercore visuals, anime or ASCII art intro, etc. Searching for the keygen feels like an internet adventure which gives similar vibe during reverse engineer.

### Encore

With all of these ideas combined, I decided to create a personal tool, a server kit, a framework to help me implement a private server. The framework should have a cool name and logo, branded with a personality, delivered with an ASCII banner, and may be operated within a desktop client app (like XAMPP).

At first, the framework is just a typical hacky dev playground. I realize it wasn't very unique, it was just cool.

After some brainstorming, I eventually picked "Encore" as the framework name. Inspired from K-pop, which means "again", it actually connects with my primary motiviation of doing private server. As if an artist is asked to perform again, a dead online game is asked by its old player to be playable again.

The logo is dark and glows in pink. This is based on my favorite color pink and black which makes a good combination. The dark side represents a dying area, while the glowy pink represents a life in a darkness. This connects with game revival idea: a dead game but enthusiastic fans tries to relive it. It's not a complete dark because it is currently being revived, likewise not a complete light because the revival is and fan-based.

#### K-pop

I thought of inserting K-pop as an identity into the framework, more than just a framework name. Although it's cringe at first, I realize that many terminologies actually fits.

Some of the renamed codebase terminologies:

- Server -> Stage
- GameServer -> GameStage
- ServerTask -> StageAct
- onExecute -> onPerform
- onComplete -> onEndingFairy
- Devtools -> Backstage
- Logger -> Fancam
- Exception/Error -> Scandal
- Warn/ing -> Rumor
- Version -> Era
- Service -> Subunit
- start/startup -> debut
- close/shutdown -> disband

...and many more...

The idea of K-pop in a somewhat hacky environment produces giggles during coding. I inserted easter eggs into the codebase which makes it more satisfying.

### Ending & Credits

Started from Nov 2025, refactored from early Feb 2026 to late May 2026, the first organized version.

The framework is not finished yet and will kep1 growing as demands increase from server implementation.

- Inspired from old internet and MMO game culture.
- Began from a revival community (thanks to **Dead Zone Revive**).
- ChatGPT for assisting with the development.
- K-pop culture for shaping the identity.

<p style="border: 1px solid black; padding: 4px;">
Special thanks to the K-pop group <strong>Kep1er</strong> for accompanying the development during April and May, which brought memorable moments.
</p>
