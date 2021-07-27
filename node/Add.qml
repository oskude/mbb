import QtQuick 2.15
import "../lib" as Lib

Lib.Node { id:root
	property int in$a
	property int in$b
	property int out$o

	// TODO: https://bugreports.qt.io/browse/QTBUG-95382
	onIn$aChanged: aTrigger()

	function aTrigger () {
		let out = in$a + in$b
		if (out$o === out) out$oChanged()
		else out$o = out
	}
}
