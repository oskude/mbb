import QtQuick 2.15
import "../lib" as Lib

Lib.Node { id:root
	property int in$chn
	property int out$on
	property int out$off
	property int out$velo: 100

	function handler (data) {
		let mtype = data[1] >> 4
		let channel = data[1] & 0xF
		if (channel !== in$chn) return
		if (mtype !== 8 && mtype !== 9) return
		if (mtype === 9) {
			if (out$on === data[2]) out$onChanged()
			else out$on = data[2]
			if (out$velo === data[3]) out$veloChanged()
			else out$velo = data[3]
			return
		}
		if (mtype === 8) {
			if (out$off === data[2]) out$offChanged()
			else out$off = data[2]
			if (out$velo === data[3]) out$veloChanged()
			else out$velo = data[3]
			return
		}
	}

	Component.onCompleted: midiin.data.connect(handler)
	Component.onDestruction: midiin.data.disconnect(handler)
}
