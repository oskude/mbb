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
				drag.smoothed: false
				drag.threshold: 0
				drag.target: root.ltr ? dragLinkLeft : dragLinkRight
				onPressed: {
					dragLink.visible = true
					let mp = mapToItem(canvas, mouse.x, mouse.y)
					// TODO: do not use .parent.parent!
					let rp = mapToItem(canvas, root.parent.parent.x, root.parent.parent.y)
					if (root.ltr) {
						dragLinkRight.x = rp.x
						dragLinkRight.y = rp.y + (root.height/2)
						dragLinkLeft.x = mp.x
						dragLinkLeft.y = mp.y
					} else {
						dragLinkLeft.x = rp.x + width
						dragLinkLeft.y = rp.y + (root.height/2)
						dragLinkRight.x = mp.x
						dragLinkRight.y = mp.y
					}
					Drag.active = true
					Drag.source = root
					Drag.keys = [root.ltr ? "in" : "out"]
				}
				onReleased: {
					dragLink.visible = false
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
