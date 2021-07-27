import QtQuick 2.15
import "../lib" as Lib

Lib.Node { id:root
	property int in$note
	property int in$velo: 100
	property int in$chn: -1 // has to be -1, so we can filter load change

	onIn$noteChanged: noteTrigger()

	function noteTrigger () {
		midiout.sendMessage(0x80+in$chn, in$note, in$velo)
	}

	// we dont want user to see -1
	Component.onCompleted: if (in$chn < 0) in$chn = 0
}
