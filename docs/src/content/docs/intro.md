---
title: Intro
slug: index
description: Intro
---

Documentation about RotMG Legacy Server.

### Version Notes

The RotMG version we used is the 27.7.DECA on 19-July-2016.

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
