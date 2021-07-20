import QtQuick 2.15
import "." as A

Rectangle { id:root
	property string label
	property int value
	property bool ltr
	property int pad: Math.round(fsize.pad / 2)
	property int yoff
	color: theme.port_bg

	width: childrenRect.width
	height: childrenRect.height

	Row {
		spacing: 8
		layoutDirection: root.ltr ? Qt.LeftToRight : Qt.RightToLeft
		A.Text {
			text: root.label
			color: theme.port_fg
			leftPadding: root.ltr ? root.pad : 0
			rightPadding: root.ltr ? 0 : root.pad
		}
		A.Text {
			text: root.value
			color: theme.port_fg
			leftPadding: root.ltr ? 0 : root.pad
			rightPadding: root.ltr ? root.pad : 0
		}
	}
}
