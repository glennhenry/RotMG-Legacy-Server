---
title: Intro
slug: index
description: Intro
---

Documentation about RotMG Legacy Server.

### Version Notes

The RotMG version we used is the 27.7.DECA on 19-July-2016.

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

_Some symbols like `_`is encoded as`%5F`\_.

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

### Pub/Sub Command Architecture

The client uses command architecture by creating class creating `Config` classes which will configure various connection between the client's components. This includes dependency injection, but most importantly, connecting `Signal` to a handler of `Command` classes.

Signal signifies an event. A successful network response may produce a signal along with the server's response data, and this will notify all components of the client that subscribes the signal.

This mean the code that reads server's response are scattered instead of in one place. To find the places, search for the signal class occurence, then find out which command class (the signal handler) does the signal get paired with. Then, find the command class and build server's response according to that.

### Objects and XML

The game uses XML file to list game data. They are called **objects**. Each of them has a _type_, which refers to their unique identifier, an index that reference their position on external assets file such as the spritesheet image.

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
