import QtQuick 2.15
import "." as A

Rectangle { id:root
	property string name
	property string type
	signal delme ()
	width: childrenRect.width
	height: childrenRect.height
	color: theme.node_bg

	MouseArea {
		anchors.fill: parent
		drag.target: parent
		drag.smoothed: false
		drag.threshold: 0
	}

	MouseArea {
		anchors.fill: parent
		acceptedButtons: Qt.RightButton
		cursorShape: Qt.SizeAllCursor
		onClicked: root.delme()
	}

	// TODO: can we construct this so that we dont need Port.yoff?
	Column {
		A.Text { id:nodeName
			text: root.type
			width: root.width > contentWidth ? root.width : contentWidth
			horizontalAlignment: Text.AlignHCenter
			color: theme.node_fg
		}
		Column { id:inPortsRoot
			anchors.left: parent.left
		}
		Column { id:outPortsRoot
			anchors.right: parent.right
		}
	}

	property var outputCallbacks: ({})
	property var portOffsets: ({})

	Component.onCompleted: {
		let inames = getPropNames("in$")
		let onames = getPropNames("out$")
		for (let iname of inames) {
			let comp = Qt.createComponent("Port.qml")
			let node = comp.createObject(inPortsRoot, {
				node: root.name,
				name: iname,
				label: iname.replace("in$", ""),
				value: Qt.binding(()=>root[iname]),
				yoff: Qt.binding(()=>nodeName.height),
				ltr: true
			})
			// TODO: hmm, i dont like this... is there a better way?
			node.onValueEdited.connect((newValue)=>{root[iname] = newValue})
		}
		for (let o in onames) {
			let oname = onames[o]
			let comp = Qt.createComponent("Port.qml")
			let node = comp.createObject(outPortsRoot, {
				node: root.name,
				name: oname,
				label: oname.replace("out$", ""),
				value: Qt.binding(()=>root[oname]),
				yoff: Qt.binding(()=>nodeName.height + inPortsRoot.height),
				ltr: false
			})
			// TODO: does user even want to change output values?
			node.onValueEdited.connect((newValue)=>{root[oname] = newValue})
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

	function getPortItem (portName) {
		if (portName.startsWith("in")) {
			let label = portName.replace("in$", "")
			for (let i in inPortsRoot.children) {
				let port = inPortsRoot.children[i]
				if (port.label === label)
					return port
			}
		} else {
			let label = portName.replace("out$", "")
			for (let i in outPortsRoot.children) {
				let port = outPortsRoot.children[i]
				if (port.label === label)
					return port
			}
		}
	}

	function exportNode () {
		let out = {
			x: root.x,
			y: root.y,
			name: root.name,
			type: root.type
		}
		let inames = getPropNames("in$")
		let onames = getPropNames("out$")
		for (let iname of inames) {
			out[iname] = root[iname]
		}
		for (let oname of onames) {
			out[oname] = root[oname]
		}
		return out
	}
}
