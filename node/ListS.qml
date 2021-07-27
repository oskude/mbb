import QtQuick 2.15
import "../lib" as Lib
import "." as Node

Node.List { id:root
	property int in$key
	property int in$oct

	function inTrigger () {
		let out = in$key + (12 * in$oct) + store$list[in$in % store$list.length]
		if (out$out === out) out$outChanged()
		else out$out = out
	}
}
