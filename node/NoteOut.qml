import QtQuick 2.15
import "../lib" as Lib

Lib.Node { id:root
	property int in$note

	onIn$noteChanged: {
		console.log("TODO: NoteOut", in$note)
	}
}
