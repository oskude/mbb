import QtQuick 2.15
import "." as A

A.Node { id:root
	property int in$beat: 120
	property int out$bang

	Timer {
		interval: Math.round(60000 / in$beat)
		running: true
		repeat: true
		onTriggered: out$bang++
	}
}
