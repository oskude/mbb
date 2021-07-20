import QtQuick 2.15
import QtQuick.Shapes 1.15
import "." as A

Rectangle { id: root
	color: theme.canvas_bg

	Item { id: nodes
		anchors.fill: parent
	}

	Shape { id: links
		anchors.fill: parent
		layer.enabled: theme.antialias > 0
		layer.samples: theme.antialias
	}

	property var linklist: []

	function clearPatch () {
		for (let i in nodes.children) {
			let node = nodes.children[i]
			node.destroy()
		}
		nodes.children = [] // NOTE: yes we need this too!
		linklist = []
		for (let i in links.data) {
			let link = links.data[i]
			link.destroy()
		}
		links.data = []
		// TODO: bug? old lines are still on screen, so add a "hidden" one...
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
			addNode(node)
		}

		for (let link of patch.links) {
			toggleLink(link[0], link[1], link[2], link[3])
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

		return JSON.stringify(out)
	}

	function addNode (opts) {
		let comp = Qt.createComponent(opts.type+".qml")
		let node = comp.createObject(nodes, opts)
	}

	function findNodeByName (name) {
		for (let i in nodes.children) {
			let node = nodes.children[i]
			if (node.name === name) return node
		}
	}

	function toggleLink (
		outNodeName,
		outPortName,
		inNodeName,
		inPortName
	) {
		// TODO: remove link if already exists
		root.linklist.push([
			outNodeName,
			outPortName,
			inNodeName,
			inPortName
		])
		let inode = findNodeByName(inNodeName)
		let onode = findNodeByName(outNodeName)
		if (!onode.outputCallbacks[outPortName]) {
			onode.outputCallbacks[outPortName] = []
		}
		onode.outputCallbacks[outPortName].push({
			node: inode,
			port: inPortName
		})
		drawLink(onode, outPortName, inode, inPortName)
	}

	function drawLink (
		onode,
		outPortName,
		inode,
		inPortName
	) {
		let oport = onode.getPortItem(outPortName)
		let iport = inode.getPortItem(inPortName)
		let comp = Qt.createComponent("Link.qml")
		let line = comp.createObject(links, {
			startX: Qt.binding(()=>onode.x + onode.width),
			startY: Qt.binding(()=>onode.y + oport.y + oport.yoff + oport.height/2),
			endX: Qt.binding(()=>inode.x),
			endY: Qt.binding(()=>inode.y + iport.y + iport.yoff + iport.height/2)
		})
		links.data.push(line)
	}
}
