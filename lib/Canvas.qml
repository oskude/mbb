import QtQuick 2.15
import QtQuick.Shapes 1.15
import "." as A

Rectangle { id:root
	color: theme.canvas_bg
	property int lastNodeId

	MouseArea {
		anchors.fill: parent
		acceptedButtons: Qt.RightButton
		onClicked: {
			let h = root.height - mouse.y
			let min = root.height - blocklist.height
			blocklist.nodePos = Qt.point(mouse.x, mouse.y)
			blocklist.y = mouse.y > min ? min : mouse.y
			blocklist.visible = !blocklist.visible
		}
	}

	Item { id:nodes
		anchors.fill: parent
	}

	Shape { id:links
		anchors.fill: parent
		layer.enabled: theme.antialias > 0
		layer.samples: theme.antialias
	}

	Shape { id:dragLink
		anchors.fill: parent
		visible: false
		layer.enabled: theme.antialias > 0
		layer.samples: theme.antialias
		A.Link {
			startX: dragLinkLeft.x
			startY: dragLinkLeft.y
			endX: dragLinkRight.x
			endY: dragLinkRight.y
			strokeColor: theme.draglink_fg
		}
	}
	Item { id:dragLinkLeft
		x:0; y:0; width:1; height:1
	}
	Item { id:dragLinkRight
		x:0; y:0; width:1; height:1
	}

	A.BlockList { id:blocklist
		visible: false
		y: root.height - height
		anchors.left: root.left
		anchors.right: root.right
		onSelected: {
			root.lastNodeId++
			newNode.name = "node" + root.lastNodeId
			addNode(newNode)
			visible = false
		}
	}

	property var linklist: []

	function clearPatch () {
		for (let i in nodes.children) {
			let node = nodes.children[i]
			node.destroy()
		}
		nodes.children = [] // NOTE: yes we need this too!
		root.lastNodeId = 0
		linklist = []
		for (let i in links.data) {
			let link = links.data[i]
			link.destroy()
		}
		links.data = []
		// TODO: bug? old lines are still on screen
		// WRKRND1: add a "hidden" one...
		links.data.push(Qt.createQmlObject(
			"import QtQuick 2.15; import QtQuick.Shapes 1.15; ShapePath{}",
			links,
			"wat"
		))
	}

	function importPatch (json) {
		let patch

		if (!json) {
			patch = {
				nodes: [],
				links: []
			}
		} else {
			try {
				patch = JSON.parse(json)
			} catch (e) {
				console.log("PATCH PARSE ERROR:", e)
				return
			}
		}

		clearPatch()

		for (let node of patch.nodes) {
			let i = parseInt(node.name.replace("node", ""))
			if (i > root.lastNodeId) root.lastNodeId = i
			addNode(node)
		}

		for (let link of patch.links) {
			addLink(link[0], link[1], link[2], link[3])
		}
	}

	function exportPatch () {
		let out = {
			nodes: [],
			links: root.linklist
		}

		for (let i in nodes.children) {
			let node = nodes.children[i]
			out.nodes.push(node.exportNode())
		}

		return JSON.stringify(out, null, "\t")
	}

	function addNode (opts) {
		let comp = Qt.createComponent("../node/"+opts.type+".qml")
		let node = comp.createObject(nodes, opts)
		node.onDelme.connect(()=>delNode(node))
	}

	function delNode (node) {
		for (let link of linklist.slice()) {
			if (link[0] === node.name || link[2] == node.name) {
				delLink(link[0], link[1], link[2], link[3])
				undrawLink(link[0], link[1], link[2], link[3])
			}
		}
		node.destroy()
	}

	function addLink (outNodeName, outPortName, inNodeName, inPortName) {
		let inode = findNodeByName(inNodeName)
		let onode = findNodeByName(outNodeName)
		if (!onode.outputCallbacks[outPortName]) {
			onode.outputCallbacks[outPortName] = []
		}
		onode.outputCallbacks[outPortName].push({
			node: inode,
			port: inPortName
		})
		linklist.push([outNodeName, outPortName, inNodeName, inPortName])
		drawLink(onode, outPortName, inode, inPortName)
	}

	function delLink (outNodeName, outPortName, inNodeName, inPortName) {
		let lidx = findInLinkList(outNodeName, outPortName, inNodeName, inPortName)
		if (lidx === null) return false
		let inode = findNodeByName(inNodeName)
		let onode = findNodeByName(outNodeName)
		if (onode) {
			for (let i in onode.outputCallbacks[outPortName]) {
				let ocb = onode.outputCallbacks[outPortName][i]
				if (
					ocb.port === inPortName
					&& ocb.node === inode
				) {
					onode.outputCallbacks[outPortName].splice(i, 1)
				}
			}
		}
		linklist.splice(lidx, 1)
		undrawLink(outNodeName, outPortName, inNodeName, inPortName)
		return true
	}

	function findNodeByName (name) {
		for (let i in nodes.children) {
			let node = nodes.children[i]
			if (node.name === name) return node
		}
	}

	function toggleLink (outNodeName, outPortName, inNodeName, inPortName) {
		if (!delLink(outNodeName, outPortName, inNodeName, inPortName))
			addLink(outNodeName, outPortName, inNodeName, inPortName)
	}

	function undrawLink (outNodeName, outPortName, inNodeName, inPortName) {
		let newdata = []
		for (let i in links.data) {
			let l = links.data[i]

			// TODO: WRKRND1
			if (!(l instanceof A.Link)) {
				newdata.push(l)
				continue
			}

			if (
				l.link[0] === outNodeName
				&& l.link[1] === outPortName
				&& l.link[2] === inNodeName
				&& l.link[3] === inPortName
			) {
				l.destroy()
			} else {
				newdata.push(l)
			}
		}

		// TODO: WRKRND1
		if (newdata.length <= 0) {
			newdata.push(Qt.createQmlObject(
				"import QtQuick 2.15; import QtQuick.Shapes 1.15; ShapePath{}",
				links,
				"wat"
			))
		}

		links.data = newdata
		// TODO: removing some lines visually show wrong line removed..
		// TODO: WRKRND2 move all the nodes to update the visuals...
		for (let i in nodes.children) {
			let node = nodes.children[i]
			node.x++
			node.x--
		}
	}

	function findInLinkList (outNodeName, outPortName, inNodeName, inPortName) {
		for (let i in linklist) {
			let l = linklist[i]
			if (
				l[0] === outNodeName
				&& l[1] === outPortName
				&& l[2] === inNodeName
				&& l[3] === inPortName
			) return i
		}
		return null
	}

	function drawLink (onode, outPortName, inode, inPortName) {
		let oport = onode.getPortItem(outPortName)
		let iport = inode.getPortItem(inPortName)
		let comp = Qt.createComponent("Link.qml")
		let line = comp.createObject(links, {
			startX: Qt.binding(()=>onode.x + onode.width),
			startY: Qt.binding(()=>onode.y + oport.y + oport.yoff + oport.height/2),
			endX: Qt.binding(()=>inode.x),
			endY: Qt.binding(()=>inode.y + iport.y + iport.yoff + iport.height/2),
			link: [onode.name, outPortName, inode.name, inPortName]
		})
		links.data.push(line)
	}
}
