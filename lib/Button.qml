import QtQuick 2.15
import "." as A

Rectangle { id:root
	property alias text: txt.text
	signal clicked()
	color: mouse.pressed ? theme.input_bg : theme.button_bg
	implicitWidth: txt.width
	implicitHeight: txt.height
	A.Text { id:txt
		color: theme.button_fg
		leftPadding: fsize.pad
		rightPadding: leftPadding
		topPadding: Math.round(fsize.pad/2)
		bottomPadding: topPadding
		MouseArea { id:mouse
			anchors.fill: parent
			onClicked: root.clicked()
		}
	}
}
