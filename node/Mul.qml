import QtQuick 2.15
import "../lib" as Lib
import "." as Node

Node.Add { id:root
	function aTrigger () {
		let out = in$a * in$b
		if (out$o === out) out$oChanged()
		else out$o = out
	}
}
