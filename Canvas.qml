import QtQuick 2.15
import "." as A

Item { id: root

	Item { id: nodes
		anchors.fill: parent
	}

	property var linklist: []

	function clearPatch () {
		linklist = []
		for (let i in nodes.children) {
			let node = nodes.children[i]
			node.destroy()
		}
		nodes.children = "" // NOTE: yes we need this too!
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
	}
}
