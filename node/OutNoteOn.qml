import QtQuick 2.15
import "../lib" as Lib
import "." as Node

Node.OutNoteOff { id:root
	function noteTrigger () {
		midiout.sendMessage(0x90+in$chn, in$note, in$velo)
	}
	Component.onDestruction: {
		function lolwait(d) {
			var t = new Date().getTime();
			while (new Date().getTime() - t < d) {}
		}
		for (let note = 0; note <= 127; note++) {
			midiout.sendMessage(0x80+in$chn, note, 127)
			lolwait(1) // TODO: is it really too fast without? or is there a bug somewhere else?
		}
	}
}
