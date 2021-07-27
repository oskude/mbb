import QtQuick 2.15
import "../lib" as Lib
import "." as Node

Node.Timer { id:root
	property int in$min
	property int in$max: 4

	function trigger () {
		let out = Math.floor(
			Math.random() * (in$max - in$min + 1) + in$min
		)
		if (out$out === out) out$outChanged()
		else out$out = out
	}
}
