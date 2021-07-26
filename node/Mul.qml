import QtQuick 2.15
import "../lib" as Lib

Lib.Node { id:root
	property int in$a
	property int in$b
	property int out$o

	onIn$aChanged: {
		let out = in$a * in$b
		if (out$o === out) out$oChanged()
		else out$o = out
	}
}
