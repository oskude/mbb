import QtQuick 2.15
import "." as A

A.Text { id:root
	text: "save"
	signal clicked()
	MouseArea {
		anchors.fill: parent
		onClicked: root.clicked()
	}
}
