# MIDI Building Blocks

Once upon a time there was a software called [Building Blocks](https://web.archive.org/web/20051102002557/http://www.midiworld.org/users/aureality/products/buildingblocks/buildingblocks.html) by [Paul Swennenhuis](https://soundcloud.com/aureality-1), and one of my fun play sessions with it looked like this:

![bb](bb.gif?raw=true)

now, i could ask if i can still buy that software (and hope it works with wine), but instead i got curious if i can create something similar, just for fun:

![mbb](mbb.png?raw=true)

## Usage

```
$ ./main.qml -- test.json
```

## Features

- simple ui-node code?
- move ui-nodes
- load/save patches
- themes (not yet user loadable)

## Deps

- qt5-base
- qt5-declarative

## ToDo

- draw link lines
- user modify links
- user modify values
- user add/del nodes
- send/receive midi
- all the ui-nodes
- user loadable themes
