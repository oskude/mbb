# MIDI Building Blocks

Once upon a time there was a software called [Building Blocks](https://web.archive.org/web/20051102002557/http://www.midiworld.org/users/aureality/products/buildingblocks/buildingblocks.html) by [Paul Swennenhuis](https://soundcloud.com/aureality-1), and one of my fun play sessions with it looked like this:

[![bb](bb.gif?raw=true)](https://osku.de/music/innerscape-betalive2.mp3)

now, i could ask if i can still buy that software (and hope it works with wine), but instead i got curious if i can create something similar, just for fun:

![mbb](mbb.gif?raw=true)

## Usage

```
$ ./main.qml
```

- Right click canvas to toggle block list
- Right click block to delete
- Left click value to edit (enter to accept)
- Left press block and drag to move
- Left press port and drag to un/link

## Features

- [simple block code](#block)
- move blocks
- load/save patches
- themes (not yet user loadable)
- visualize link lines
- user modify links
- user modify values
- user add/del blocks

## Deps

- qt5-base
- qt5-declarative

## ToDo

- send/receive midi
- implement all the blocks
- user loadable themes
- show line when user modifies link
- should we even store output values to json?
- should Drag.keys also affect the mouse cursor?
- update to Qt 6 when KDE does ;P

# Development

This documentation assumes you know the [basics of QML](https://doc.qt.io/qt-5/qtqml-syntax-basics.html), and:

- [Property change signal handlers](https://doc.qt.io/qt-5/qtqml-syntax-signals.html#property-change-signal-handlers) do not trigger if the value did not change when you set it. so if you still want to trigger a change, call `<property>Changed()`

## Block

To create a new block, make a qml file in `node` directory with the name of your block (eg. `node/Random.qml`) and extend `lib/Node.qml`:

```qml
import QtQuick 2.15
import "../lib" as Lib

Lib.Node {}
```

Define your inputs and outputs with properties that start with `in$` and `out$`:
```qml
Lib.Node {
	property int in$bang
	property int in$min: 0
	property int in$max: 3
	property int out$rand
}
```

Listen for changes in `in$*` properties, and change `out$*` properties:
```qml
Lib.Node {
	property int in$bang
	property int in$min: 0
	property int in$max: 3
	property int out$rand

	onIn$bangChanged: {
		let rand = Math.floor(
			Math.random() * (in$max - in$min + 1) + in$min
		)
		if (out$rand === rand) out$randChanged()
		else out$rand = rand
	}
}
```

And that's it, all the rest is done automagically :P (Well, cause vanilla QML cannot get directory listings, you have to also manually add the new block to `blocks.json`, to be able to add it through the ui)

> Please note: at the moment i don't have any use case for custom ui items for a block, but i can imagine that we want them at some point...

## The Magic

TODO: document the rest when it all works as intended...

---

This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.
