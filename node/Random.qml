import QtQuick 2.15
import "../lib" as Lib

Lib.Node { id:root
	property int in$in
	property int in$min: 0
	property int in$max: 3
	property int out$out

	onIn$inChanged: {
		let out = Math.floor(
			Math.random() * (in$max - in$min + 1) + in$min
		)
		if (out$out === out) out$outChanged()
		else out$out = out
	}
}
