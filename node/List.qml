import QtQuick 2.15
import "../lib" as Lib

Lib.Node { id:root
	property int in$in
	property int out$out
	property var store$list: [1, 2, 3]

	Component { id:customUI
		Column {
			Row {
				spacing: fsize.pad
				anchors.horizontalCenter: parent.horizontalCenter
				Repeater {
					model: root.store$list
					Lib.TextVal {
						text: modelData
						onEdited: root.store$list[index] = parseInt(text)
					}
				}
			}
			Row {
				spacing: fsize.pad
				anchors.horizontalCenter: parent.horizontalCenter
				Lib.Button {
					text: "-"
					onClicked: {
						root.store$list.splice(-1, 1)
						root.store$listChanged()
					}
				}
				Lib.Button {
					text: "+"
					onClicked: {
						root.store$list.push(0)
						root.store$listChanged()
					}
				}
			}
		}
	}

	onIn$inChanged: inTrigger()

	function inTrigger() {
		let out = store$list[in$in % store$list.length]
		if (out$out === out) out$outChanged()
		else out$out = out
	}
}
