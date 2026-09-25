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
