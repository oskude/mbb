# MIDI Building Blocks

Once upon a time there was a software called [Building Blocks](https://web.archive.org/web/20051102002557/http://www.midiworld.org/users/aureality/products/buildingblocks/buildingblocks.html) by [Paul Swennenhuis](https://soundcloud.com/aureality-1), and i got curious if i can create something similar, just for fun...

![mbb](mbb.gif?raw=true)

## Usage

```
$ ./main.qml
```

- Right click canvas to toggle block list
- Right click block to delete
- Left click value to edit
- Left press block and drag to move
- Left press port and drag to un/link
- [Tab] key to jump throgh value inputs

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
- trigger ports with mouse click?
- should Drag.keys also affect the mouse cursor?
- update to Qt 6 when KDE does ;P

# Development

This documentation assumes you know the [basics of QML](https://doc.qt.io/qt-5/qtqml-syntax-basics.html), and:

- [Property change signal handlers](https://doc.qt.io/qt-5/qtqml-syntax-signals.html#property-change-signal-handlers) do not trigger if the value did not change when you set it. so if you still want to trigger a change, call `<property>Changed()`
- multiple `on<Property>Changed:` definitions for the same property do NOT overwrite the previous ones! (you can call a function from there instead, as functions are overwritten by extenders)

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

If you want to save/load other values to/from the json file, prefix your properties with `store$`:
```qml
Lib.Node {
	property var store$list: [1,2,3]
}
```

If you want to add custom UI for your node, create a component with id `customUI`:
```qml
Lib.Node {
	Component { id:customUI
		/* your items */
	}
}
```

If you want to extend another ui node, and overwrite it's property listeners, you have to use a function workaround, see [`node/Add.qml`](node/Add.qml) and [`node/Mul.qml`](node/Mul.qml) for an example.

## The Magic

TODO: document the rest when it all works as intended...

---

This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.
