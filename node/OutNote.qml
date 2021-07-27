import QtQuick 2.15
import "../lib" as Lib
import "../lib/global.js" as G
import "." as Node

Node.OutNoteOn { id:root
	property int in$time

	property int prevNote: 0

	function noteTrigger () {
		if (in$chn < 0)
			return // filter load change
		if (in$time > 0) {
			G.delaySendMsg(root, midiout, in$time, [0x80+in$chn, in$note, 127])
			if (prevNote >= 0) {
				midiout.sendMessage(0x80+in$chn, prevNote, 127)
				prevNote = -1
			}
		} else {
			midiout.sendMessage(0x80+in$chn, prevNote, 127)
		}
		prevNote = in$note
		midiout.sendMessage(0x90+in$chn, in$note, 127)
	}
}
