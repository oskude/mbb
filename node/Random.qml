import QtQuick 2.15
import "../lib" as Lib

Lib.Node { id:root
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
