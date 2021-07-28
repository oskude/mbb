import QtQuick 2.15

FocusScope { id:root
	property alias text: txt.text
	property bool ltr
	property int pad
	signal edited(string newText)
	activeFocusOnTab: true
	width: rect.width
	height: rect.height
	Rectangle { id:rect
		width: txt.width
		height: txt.height
		color: root.activeFocus ? theme.input_bg : "transparent"
		TextInput { id:txt
			anchors.horizontalCenter: parent.horizontalCenter
			color: root.activeFocus ? theme.input_fg : theme.port_fg
			selectedTextColor: theme.input_sel_fg
			selectionColor: theme.input_sel_bg
			leftPadding: root.ltr ? 0 : root.pad
			rightPadding: root.ltr ? root.pad : 0
			font.family: theme.font_family
			font.pointSize: theme.font_point
			selectByMouse: true
			focus: true
			onActiveFocusChanged: if (activeFocus) selectAll()
			Keys.onEscapePressed: root.focus = false
			onEditingFinished: {
				root.edited(text)
				root.focus = false
			}
			// NOTE: just to get mouse cursor change
			MouseArea {
				anchors.fill: parent
				enabled: false
				cursorShape: Qt.IBeamCursor
			}
		}
	}
}
