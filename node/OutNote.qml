import QtQuick 2.15
import "../lib" as Lib
import "../lib/global.js" as G

Lib.Node { id:root
	property int in$note
	property int in$velo: 100
	property int in$chn
	property int in$mono: 1
	property int in$time: 100

	property int monoPrevNote: -1

	onIn$noteChanged: {
		// if mono, note-off previous note
		if (in$mono > 0) {
			if (monoPrevNote < 0) {
				monoPrevNote = in$note
			} else {
				midiout.sendMessage(0x80+in$chn, monoPrevNote, 127)
				monoPrevNote = in$note
			}
		}
		// else start timer for note off
		else if (in$time > 0) {
			G.delaySendMsg(root, midiout, in$time, [0x80+in$chn, in$note, 127])
			if (monoPrevNote > 0) {
				midiout.sendMessage(0x80+in$chn, monoPrevNote, 127)
				monoPrevNote = -1
			}
		}

		midiout.sendMessage(0x90+in$chn, in$note, 127)
	}
}
