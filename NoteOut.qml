import QtQuick 2.15
import "." as A

A.Node { id:root
	property int in$note

	onIn$noteChanged: {
		console.log("TODO: NoteOut", in$note)
	}
}
