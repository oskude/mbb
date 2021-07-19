import QtQuick 2.15
import "." as A

Rectangle { id:root
	property string name
	property string type
	width:  childrenRect.width
	height: childrenRect.height

	MouseArea {
		anchors.fill: parent
		drag.target: parent
		drag.smoothed: false
		drag.threshold: 0
		cursorShape: Qt.SizeAllCursor
	}

	Column {
		A.Text {
			text: root.type
			width: root.width
			horizontalAlignment: Text.AlignHCenter
		}
		Column { id:inPortsRoot
			anchors.left: parent.left
		}
		Column { id:outPortsRoot
			anchors.right: parent.right
		}
	}

	property var outputCallbacks: ({})

	Component.onCompleted: {
		let inames = getPropNames("in$")
		let onames = getPropNames("out$")
		for (let iname of inames) {
			let comp = Qt.createComponent("Port.qml")
			let node = comp.createObject(inPortsRoot, {
				label: iname.replace("in$", ""),
				value: Qt.binding(()=>root[iname]),
				ltr: true
			})
		}
		for (let o in onames) {
			let oname = onames[o]
			let comp = Qt.createComponent("Port.qml")
			let node = comp.createObject(outPortsRoot, {
				label: oname.replace("out$", ""),
				value: Qt.binding(()=>root[oname]),
				ltr: false
			})
			let Oname = oname.charAt(0).toUpperCase() + oname.slice(1)
			root["on"+Oname+"Changed"].connect(function(){
				if (!root.outputCallbacks[oname]) return
				for (let cb of root.outputCallbacks[oname]) {
					if (cb.node[cb.port] === root[oname]) {
						cb.node[cb.port+"Changed"].call()
					} else {
						cb.node[cb.port] = root[oname]
					}
				}
			})
		}
	}

	function getPropNames (prefix) {
		let props = []
		for (let prop in root) {
			if (
				prop.startsWith(prefix)
				&& !prop.endsWith("Changed")
				) {
				props.push(prop)
			}
		}
		return props
	}

	function exportNode () {
		let out = {
			x: root.x,
			y: root.y,
			name: root.name,
			type: root.toString().split("_")[0],
			inputs: {},
			outputs: {}
		}
		let inames = getPropNames("in$")
		let onames = getPropNames("out$")
		for (let iname of inames) {
			out.inputs[iname] = root[iname]
		}
		for (let oname of onames) {
			out.inputs[oname] = root[oname]
		}
		return out
	}
}
