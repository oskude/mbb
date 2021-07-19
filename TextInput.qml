import QtQuick 2.15
import "." as A

Rectangle { id: root
	property alias text: txtin.text
	signal edited ()
	height: txtin.contentHeight
	TextInput { id:txtin
		width: parent.width
		font.family: "monospace"
		font.pointSize: 8
		onAccepted: {
			root.edited()
			focus = false
		}
	}
}
