import QtQuick 2.15
import "../lib" as Lib
import "." as Node

Node.ListS { id:root
	function inTrigger () {
		let out = in$key + (12 * in$oct) + store$list[
			Math.floor(Math.random() * store$list.length)
		]
		if (out$out === out) out$outChanged()
		else out$out = out
	}
}
