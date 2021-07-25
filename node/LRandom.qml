import QtQuick 2.15
import "../lib" as Lib

Lib.Node { id:root
	property int in$bang
	property int in$key
	property int in$oct: 5
	property int in$len: 4
	property int in$v1: 1
	property int in$v2: 2
	property int in$v3: 3
	property int in$v4: 4
	property int in$v5: 5
	property int in$v6: 6
	property int in$v7: 7
	property int in$v8: 8
	property int out$rand

	onIn$bangChanged: {
		let rand = in$key + (12 * in$oct) + root[
			"in$v" + Math.ceil(Math.random() * in$len)
		]
		if (out$rand === rand) out$randChanged()
		else out$rand = rand
	}
}
