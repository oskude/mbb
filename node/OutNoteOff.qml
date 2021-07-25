import QtQuick 2.15
import "../lib" as Lib

Lib.Node { id:root
	property int in$chn
	property int in$note
	property int in$velo

	onIn$noteChanged: {
		midiout.sendMessage(0x80+in$chn, in$note, in$velo)
	}
}
