import QtQuick 2.15
import "." as A

Rectangle { id:root
	property string label
	property int value
	property bool ltr

	width: childrenRect.width
	height: childrenRect.height

	Row {
		spacing: 8
		layoutDirection: root.ltr ? Qt.LeftToRight : Qt.RightToLeft
		A.Text {
			text: root.label
		}
		A.Text {
			text: root.value
		}
	}
}
