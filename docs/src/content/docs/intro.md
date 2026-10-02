---
title: Intro
slug: index
description: Intro
---

Documentation about RotMG Legacy Server.

### Version Notes

The RotMG version we used is the 27.7.DECA on 19-July-2016.

### Absence of SFX files

Many sfx files are lost such as characters and enemies sound effect (hit, shoot, death sounds).

### Edit List

These were the edits done to `client.swf` before being tracked by Git.

1. Changed domain `ProductionSetup.as@line 9` to localhost address.
2. Changed domain `CompileTimeBuildData.as@line 14,16` to localhost address.
3. Changed default parameter value to `true` for app engine connection into unencrypted (to use http) `ProductionSetup.as@line 24`.
4. Enabled the junkbyte console `WebMain.as@line 92` by allowing command line, adding console initiation, as well as adding import.
5. Changed port number to 7777 and disable encryption `Parameters.as@line 21, 23`.

### Networking

RotMG networking so far is simple. It's just HTTP POST request. The RotMG server is the appspot `realmofthemadgodhrd.appspot.com`. It also uses optional encryption.

:::note
For setup, edit the appspot URL to localhost and disable encryption for simplicity.
:::

In more details, the client build its own networking client utilities called **app engine**. The client typically uses the retry-able engine. Any request goes through the engine with a URL and AS3 objects as payload for server.

The objects payload is converted into Flash AS3 `URLVariables`. It's a Flash built-in system to deliver client variables to server. The encoding system is a simple URL form, that is a key-value pair like what you see in URL.

Instead of `localhost/app?param1=value1&param2=value2` the game simply requests to `POST localhost/app` and the body is `param1=value1&param2=value2`.

Some symbols like `_` is encoded as `%5F`.

The server response vary from XML and JSON.

### Strings

The game first request a string table in format of JSON array. The JSON file must be an array `[]` not `{}`. Each element of the array is another array of length 3, where the first element is string identifier, the second is string text, and the third is the language code identifier.

Example:

```json
[
  [
    "textiles.Large_Purple_Pinstripe_Cloth",
    "Large Purple Pinstripe Cloth",
    "en"
  ]
]
```

It's possible to clean up the JSON into a better looking format since the game never featured multiple languages anyway. This can be done easily by editing the `GetLanguageService.as`.

### Console

The game has a built-in console of "junkbyte". This can be enabled by simply adding these piece of code anywhere `DisplayObject` is available (such as the main class):

```
import com.junkbyte.console.Cc;

Cc.config.commandLineAllowed = true;
Cc.startOnStage(this,"`");
```

where "`" is the hotkey to enable.

Example usage of logging:

```
import com.junkbyte.console.Cc;

Cc.log("message here...")
```

### Pub/Sub Command Architecture

The client uses command architecture by creating class creating `Config` classes which will configure various connection between the client's components. This includes dependency injection, but most importantly, connecting `Signal` to a handler of `Command` classes.

Signal signifies an event. A successful network response may produce a signal along with the server's response data, and this will notify all components of the client that subscribes the signal.

This mean the code that reads server's response are scattered instead of in one place. To find the places, search for the signal class occurence, then find out which command class (the signal handler) does the signal get paired with. Then, find the command class and build server's response according to that.

### Objects and XML

The game uses XML file to list game data. They are called **objects**. Each of them has a _type_, which refers to their unique identifier in the XML file.

The index that the XML files use is a hexadecimal value like `0x164`. Important: the server should list a decimal value.

### Account and Login

RotMG rely on Flash's `SharedObject`, that is the local storage stored on user's computer.

When you open the game on `realmofthemadgod.com` (not Kongregate, Kabam, or anywhere else that has auth process before), it will show you guest account, unless you have registered/login before. When you have an account, there will be shared object cookie on your PC, and the game will use that.

In other word, what determine whether a user is logged in or not is their Flash cookie instead of the server. The server merely sends the account information like account ID, name, is email verified, character data, and many more.

So, it's possible for guest account to have every stuff, because guest or not is determined by cookie, and server can return anything.

### Socket Server

The gameplay is done with a socket connection. The communication by default uses an encryption of RC4. This can be disabled by editing the client. Relevant networking code are located in `kabam.lib.net.impl` and `kabam.rotmg.messaging`. The outgoing directory contains all messages sent to server, while the incoming directory contains all client expectation from server.

On connect to the socket, the client will always send the Adobe policy file request. After server responds to this successfully, the `onConnected` signal will be dispatched and the next message to be sent by client is the `Hello` message. This can be seen in `GameServerConnectionConcrete.as@line 961`.

The low-level networking logic which involves packing or encoding/decoding message is located in `SocketServer.as`. The `sendMessage` is used to initiate, while the `sendPendingMessage` is used to actually send the message to the server. The `onSocketData` on the other hand contains the code that reads the message from server.

#### Message List

Apparently, the messaging system structure itself like a linked-list. A `Message` (`kabam.net.lib.impl.Message`) is a representation of an incoming server message or outgoing client message. Each message has a next and previous reference of message.

First, the list is initialized with a placeholder for head and tail. When `SocketServer.sendMessage` is called, this will set that message as the new tail, and also changing the previous tail's next to this. This creates a queue-like system where earlier initiated `sendMessage` will be guaranteed to be sent first than a later initiated `sendMessage` (first-in, first-out). It also guarantees that no message will be lost as they are queued until socket connection is graceful.

Example:

```
head = .
tail = .

sendMessage(A)
tail.next = A
. -> A
head = .
tail = A

sendMessage(B)
A.next = B
. -> A -> B
head = .
tail = B

sendMessage(C)
B.next = C
. -> A -> B -> C
head = .
tail = C
```

Then, when the socket is connected, `sendPendingMessages` will be called and the processing will start from the next of head, which is `A`, and progress further until there are no more next element.

#### Outgoing Wire Format

A `Message` is a representation of an incoming server message or outgoing client message.

Each message is associated with a message ID, basically an opcode which is a number. The exhaustive list is listed at `rotmg.messaging.impl.GameServerConnection`. Each operation is associated with a `Message` class that act as the structure of that message.

**The data format for message is binary**. It doesn't use specific format like ProtoBuf, JSON, MsgPack, or anything else, but a raw binary format written by each classes that implements the `Message` class. Implementing the `Message` class means implementing the method `writeToOutput`, which should contains the packaging logic of that class's data.

For example, the first `Hello` message has an ID of 83. It encapsulates various data like `buildVersion`, `gameId`, `guid`, `password`, and many more. The `writeToOutput` contains the logic to package all these data into the binary format. This utilizes Flash built-in functions like `writeUTF`, `writeInt`, etc.

:::note
The `Hello` message is a fixed message sent at the beginning of connection. It sort of act like the authentication to the socket server. The `guid`, `password`, and `secret` are specifically RSA encrypted.
:::

So, each `Message` class's `writeToOutput` produces a binary data. This binary data is then modified further inside `SocketServer.sendPendingMessage`.

- If encryption is enabled, that data will be encrypted with the set outgoing cipher.
- Before the data, an **integer** of the data length + 5 is written. This represents the length of the entire payload, where its the data length itself with 4 bytes for this integer, and another 1 byte for the next...
- A byte which is the message ID.

This structures the message like

```
4 bytes int               1 byte byte
[messageLength + 5 bytes] [message ID]    [data]
```

#### Incoming Wire Format

The message response from server is very similar with the outgoing message from client.

- An integer (4 bytes) is read, representing the entire message length.
- An unsigned byte (1 byte) is read, representing the message ID.
- The data payload, with optional decryption if incoming cipher was set.

Then, the client requires the incoming message structure to be same as what the client expects. Those typically implements the `IncomingMessage` and the method `parseFromInput` which does similar like `writeToOutput` with Flash built-in method like `readUnsignedByte`, `readInt`, `readShort`, etc.

:::tip
If outgoing cipher is set, then so is the incoming. This can be modified from `Parameters.as` `ENABLE_ENCRYPTION`.
:::

#### Encryption

There are two mode of encryption used for the network communication.

1. Symmetric encryption with RC4. The client allows optional encryption mode via `Parameters.as`. If this is enabled, then network communication of client to server and vice versa will be encrypted. This means a cipher is needed to decrypt the message on client and on server end. The cipher is hardcoded in `GameServerConnectionConcrete.as`.
2. Asymmetric encryption with RSA. The client transmit sensitive information like password and email with RSA. The message direction is one way — the client encrypts a message and the server decrypts it. This means a pair of public and private key is needed for communication. The public key is hardcoded in the client `Parameters.as`. However, the server does not own any private key. This means in order to continue the communication with RSA, a new pair of key has to be regenerated. Subsequently, the hardcoded public key of client has to be edited.

### Problem With Local Client

For some reasons, running the `client.swf` locally never work. It just stuck connecting to the socket and the server never receives anything. The server already sent the correct stuff and it even works with the web.

Even after hardcoding socket connection to the localhost and port, the client just never wants to connect.

### Object System

In the game, everything is considered an "object." This includes portals (e.g., vault, realm, pet yard), static objects (trees, decorations), player character and other people, projectiles, items and consumables, enemy mobs, and others.

Each object has unique ID for referencing, a position in the world, and `ObjectStatusData` which tells the details of that object. The status specifies exhaustively, this includes things like max HP stats, max attack stats, occupied items in inventory slot, texture such as player skin and cloths, fame stats, level exp, sprite size, pet stats, and many more.

In other word, an object represent "something" that exists in the game. The status represent the details of that object. Because of the diversity of an object, the status is also diverse. This means not every object always have status.

For example, a vault portal doesn't need dex stats, a player object needs everything from stats, fame, level, texture (player skin), and many more, while pet object needs anything that a pet would need. Probably, enemy mobs don't need stat like HP or damage, because they are encoded in the `Objects.xml`.

Different status gets interpreted differently depending on the object. A dex stat on player tells the dex stats, while on it Potion of Dexterity, it tells the stat increase when consuming.

Object also has a type. This is encoded in client-server communication with integer, but it's actually listed in `Objects.xml` as hexadecimal like `0x221`. The hex tells you the index of the object in the XML file.

### Message Guessing & Flow

After socket is successfully connected, the client send a fixed `Hello` message.

However, there is no set response from the server. The client never pairs any kind of message with any kind of response. The communication happens two-way: client send, server may response, and server can send anytime without client's request.

Because of that, networking can be a tiring guessing effort.

- I found that I can respond `MapInfo` after `Hello`, prompting the client to send `Create` message.
- `Create` is responded with `CreateSuccess`.
- I also re-send `MapInfo` after `CreateSuccess` to prompt the client to send `Load` message.
- The `Load` message is responded with the `Update` message. The server will send `UpdateAck` after this.
- After that, the client will actually enter the world and player can start gameplay interaction.

The flow:

1. Client > `Hello` (used for auth/identification of player, fixed)
2. Server > `MapInfo` (provide details about world data, map, and objects data, server-initiated)
3. Client > `Create` (initiate character creation; for guest account this is wizard class; request initiated after `MapInfo` if character hasn't been created yet.)
4. Server > `CreateSuccess` (acknowledge character creation, response for `Create`)
5. Server > `MapInfo` (to prompt the `Load` message, server-initiated)
6. Client > `Load` (load the world data, request initiated after `MapInfo` if character is already created)
7. Server > `Update` (to provide the world and objects data, response for `Load`)

And finally, the client enters the game and player can start gameplay interaction.

In the map info, there is entries of XML files and extra XML files. We gave every XML files we have in the assets to the client. Allegedly, this is the process where server provides objects data for client.

### Loading World

The `Load` request message tells the server to return an `Update` message which should include the world data. For first time loading the game, this will always be the nexus area.

By world data, for example the nexus, this includes:

- Portals like vault, pet yard, etc.
- Objects like shop, mystery box, etc.
- Player characters like own character and other player characters. The character object must include object status of stats like hp, mp, equipment and inventory slots, optionally backpack, pet, and many more.

### Better Message Guessing

After more inference, my guess now:

- `Hello` message is a player identification in the socket connection. It can be seen that the player sends GUID for server to identify.
- The expected response is `MapInfo`, telling player which world to be spawned in.
- It is expected for client to send `Create`, prompting the server to create a player object in the world.
- The response would be `CreateSuccess`, an acknowledgement as well as telling the client the `objectId` for the player character.
- After that, the server should resend `MapInfo`, prompting the client to send a `Load` message.
- The `Load` message is send, this signify a client first load to a map. When client enters a nexus, a dungeon, a realm, the `Load` request will be done once. The expected response from server is the `Update`.
- The `Update` represent a world objects update which includes any new tiles, objects, or removal of objects. For the first `Load`, the `Update` should contain the entire world's tiles, and objects.

After that, gameplay starts happening.

#### About Update

The update is crucial message for client. An update message contains `newTiles`, `newObjects`, and `drops`.

- `newTiles` represent when a "new" tile is added to the world (or changed from an existing tile).
- `newObjects` represent when a "new" object is added to the world.
- `drops` represent when any old objects is supposed to be removed.

Gameplay details:

- When player moves to a new area in the same world, `newTiles` don't need to be sent because `newTiles` is only when a tile changes. For example, the `newTiles` is required for case like Sentinel's bridge shrinking. The `newTiles` in the first `Update` of `Load`'s response is instead used to send the entire world's tile.
- On the other hand, `newObjects` is used when a new object get spawned into the world. For example, enemy spawning, loot bag dropping, or just area changes (like spawn of Skull Shrine's wall). This includes the first `Update` response, because every objects is inherently new to the client.
- And, the `drops` sent during `Update` represent the list of `objectsId` to be removed from the world. Maybe an enemy died, so the `objectId` of that enemy should be included in the `drops` update. For first `Update`, this would be empty.

#### Gameplay Message

##### Player Shoot

After entering world, any subsequent request/response happens after client interaction.

- When a player shoot, the server should verify that shot (ensure correct bullet) and returns the damage. This is done via `PlayerShoot` message to server, then `ServerPlayerShoot` from server to client.
- After `ServerPlayerShoot`, a `ShootAck` will be sent to server.
- If a player shot hits an enemy, an `EnemyHit` message will be sent to the server as well. Server does not respond anything for this, but it is expected for server to update enemy tracking such as HP.
- If enemy die for example, an `Update` message containing `drops` of the enemy `objectId` should be send. This will tell the client to delete that enemy.
- If the player obtains a loot, a new object of loot bag should be send along the previous `Update` message.

##### Enemy Shoot

- The enemy shots are initiated by server, but animated by client.
- The server is expected to initate a shot, maybe using a timer.
- The shots message uses the `EnemyShoot` message.
- The message contains `bulletId`, a unique identifier, `ownerId`, referring to which `objectId` does the bullet comes from, and a `bulletType` which refers to which entry of bullet in the enemy's projectiles entry.
- This `bulletType` isn't arbitrary projectiles object, but is limited to the enemy's projectiles entry. This means an arbitrary enemy can't shoot an arbitrary projectiles unless the `Objects.xml` of that enemy is edited so that the arbitrary projectile is listed there.
- A starting position, number of shots, and angle increase is also provided.

For example, the server only needs to send like the `objectId` of a spawned Oryx 2, shooting 3 shots projectile of some type of bullet, and at some angle. The client will lookup the object and projectile entry, then start the bullet at the given position and angle increase. The movement of bullet is animated by client.

If a bullet is supposed to be wavy, the server doens't need to tell the wave parameters, but it's already listed in the projectiles entry.

As for the status, it is also listed in the entry. On the other hand, although damage is listed in the entry, the server can override it.

##### Player Hit

This is unimplemented in our server.

When a player is hit, the server receives a `PlayerHit` message. The server should update tracking which includes: decreasing player's HP and deciding whether the player is dead or not, applying status effect to decrease player's ability, then sending a periodic tick to update the status effect duration.

The server should also modify player's health automatically because of healing from source like pet and vitality stats. Other manual source like consumables or other players healing are intiated from client's input.

##### Enemy Movement

A movement is represented with the `GotoMessage`. It represents a movement of some `objectId` to a coordinate `x` and `y`. Allegedly, a `GotoMessage` will be very frequently sent to client, maybe more than 5 times in a second.

Though, the `Goto` message moves an object directly without smooth animation. I don't know whether smooth movement is created by making a lot of `GotoMessage` or is there any other message capable of it.

Unless the movement is very small and frequent and included with a smart movement system instead of just random movement, this would be very resource consuming considering the amount of enemy in the area you would need to update, and not including other instance, server, or other kind of messages.

Enemy movement probably vary alot:

- Static - no movement.
- Set movement: enemies move from one position to other position.
- Non-aggresive chasing: The server would likely track's player movement and make the enemy follow that, but this isn't too aggresive. Maybe it would stop until certain range to player.
- Aggresive chasing: This would chase player aggresively to the point of sitting in the player.
- Random movements: This is the most important movement for non-static enemy. It's about randomly moving the enemy in-place to prevent the player from hitting the enemy too easily.

### Update Loop

The game is heavily structured on objects and the `Update` message. A server loop would look like this:

1. Starting from a fixed map with fixed tiles and objects.
2. Server spawns objects like enemies based on timer or after interaction (e.g., killing ent ancient spawns quest boss).
3. The spawn broadcasts an `Update` to all players in the instance.
4. Player sees the object, interact with them. For enemies, this meant player hitting and killing them.
5. When the enemy dies, the server world objects should be updated. An `Update` of the removal of that object should be broadcasted to every players. A loot bag would also be included in the `Update`, which includes public loot bag (brown/pink bag) and the soulbound bag (purple, blue, white, etc).
6. Players interact with that loot object. If it's a public loot bag and every loot is taken, the server is notified and should remove the loot bag from the world objects as well as sending a public broadcast to all players. If it's a soulbound loot, it would be removed from the world objects in the player's view. An `Update` may be sent to the player only.
7. Repeat to 2, server spawning enemies again.

### Possible Implementation

#### Objects

The lack of object-oriented design of the game's objects system can limit server's code logic.

Maybe it would be better to design an object system in the server like:

- `Objects` is an interface of any object.
- `PlayerCharacter`, `EnemyMobs`, `StaticObjects`, `Portal`, `NPC`, `Equipment`, `StatPotions`, `Keys`, and many more are sub-interface of detailed type of objects. Each of them has different properties.
- `Objects` must have `objectId` (used as constructor), `objectType` to identify them in `Objects.xml`, and `name` for logging purpose.
- There would also be utility that reads the XML file and have the ability to convert in-between client's object model and server's object-oriented model.
- This is like converting client's `ObjectData` which includes the status entries.
- For example, `StatPotions` may have `amountDex`, `amountAtk`, etc. A "Potion Of Dexterity" has `amountDex=1` and rest is 0. `StatPotions` may implement methods like `toClientModel` which convert itself into client's object data with the according `objectType` and status of `STAT_DEX` equal to 1.
- An `EnemyMobs` is an important abstraction because enemy shots and movements timing are done by server. Maybe each enemy would implements its own timing system and the server can call it to run easily. For example, "shtrs The Forgotten King" may implement `projectile1` that shots the Fire Bullet as tentacles, `projectile2` used as the patience phase, and so on. There is also set movement like `movement1` for set movement, then maybe `movement2` for other phase movements.

#### Timer

In the server, timing system is very important.

- Enemy shoot requires a timer interval where the server periodically sends shots message to client.
- Enemy movement requires a timer interval where the server sends new position of object to client.
- Enemy spawn every some times.

#### Procedural Generation

This is needed to generate the realm (can be pre-generated) and most importantly dungeons map.

Maybe the Undead Lair dungeon has a minimal of 10 rooms before boss. The server generates room with varying size and contains various enemies.
