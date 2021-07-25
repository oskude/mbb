import QtQuick 2.15
import "." as A

Rectangle { id:root
	property string node
	property string name
	property string label
	property int value
	property bool ltr
	property int pad: Math.round(fsize.pad / 2)
	property int yoff
	signal valueEdited(string newValue)
	color: theme.port_bg
	width: childrenRect.width
	height: childrenRect.height
	anchors.left: ltr ? parent.left : undefined
	anchors.right: ltr ? undefined : parent.right

	Row {
		spacing: 8
		layoutDirection: root.ltr ? Qt.LeftToRight : Qt.RightToLeft
		A.Text {
			text: root.label
			color: theme.port_fg
			leftPadding: root.ltr ? root.pad : 0
			rightPadding: root.ltr ? 0 : root.pad
			MouseArea {
				anchors.fill: parent
				cursorShape: Qt.DragLinkCursor
				onPressed: {
					Drag.active = true
					Drag.source = root
					Drag.keys = [root.ltr ? "in" : "out"]
				}
				onReleased: {
					Drag.hotSpot = Qt.point(mouseX, mouseY)
					Drag.drop()
				}
			}
			DropArea {
				anchors.fill: parent
				keys: [root.ltr ? "out" : "in"]
				onDropped: {
					if (root.ltr) {
						toggleLink(drop.source.node, drop.source.name, root.node, root.name)
					} else {
						toggleLink(root.node, root.name, drop.source.node, drop.source.name)
					}
				}
			}
		}
		A.TextVal {
			text: root.value
			ltr: root.ltr
			pad: root.pad
			onEdited: root.valueEdited(text)
		}
	}
}
