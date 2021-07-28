import QtQuick 2.15
import "." as A

Rectangle { id:root
	property var blocks: []
	property point nodePos
	signal selected(var newNode)
	color: theme.window_bg
	implicitHeight: childrenRect.height

	Flow {
		width: root.width
		spacing: fsize.pad
		padding: fsize.pad
		Repeater {
			model: root.blocks
			A.Button {
				text: modelData
				onClicked: {
					root.selected({
						x: nodePos.x,
						y: nodePos.y,
						type: text
					})
				}
			}
		}
	}

	Component.onCompleted: {
		let file = readFile("blocks.json")
		blocks = JSON.parse(file)
	}
}
