import QtQuick 2.15

Rectangle { id: root
	property alias text: txt.text
	property bool ltr
	property int pad
	signal edited(string newText)
	width: txt.width
	height: txt.height
	color: txt.focus ? theme.input_bg : "transparent"
	TextInput { id:txt
		anchors.horizontalCenter: parent.horizontalCenter
		color: focus ? theme.input_fg : theme.port_fg
		leftPadding: root.ltr ? 0 : root.pad
		rightPadding: root.ltr ? root.pad : 0
		font.family: theme.font_family
		font.pointSize: theme.font_point
		selectByMouse: true
		Keys.onEscapePressed: focus = false
		onAccepted: {
			root.edited(text)
			focus = false
		}
		// NOTE: just to get mouse cursor change
		MouseArea {
			anchors.fill: parent
			enabled: false
			cursorShape: Qt.IBeamCursor
		}
	}
}
