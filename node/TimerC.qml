import QtQuick 2.15
import "../lib" as Lib
import "." as Node

Node.Timer { id:root
	property int in$reset

	onIn$resetChanged: reset()

	function trigger () {
		out$out++
	}

	function reset () {
		out$out = in$reset
	}

	// workaround to get first change to 0
	Component.onCompleted: out$out = -1
}
