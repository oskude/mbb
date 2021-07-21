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

	function toggleLink (outNodeName, outPortName, inNodeName, inPortName) {
		let lidx = findInLinkList(outNodeName, outPortName, inNodeName, inPortName)
		let inode = findNodeByName(inNodeName)
		let onode = findNodeByName(outNodeName)
		if (lidx !== null) {
			linklist.splice(lidx, 1)
			for (let i in onode.outputCallbacks[outPortName]) {
				let ocb = onode.outputCallbacks[outPortName][i]
				if (ocb.port === inPortName) {
					onode.outputCallbacks[outPortName].splice(i, 1)
					break
				}
			}
			undrawLink (outNodeName, outPortName, inNodeName, inPortName)
		} else {
			linklist.push([outNodeName, outPortName, inNodeName, inPortName])
			if (!onode.outputCallbacks[outPortName]) {
				onode.outputCallbacks[outPortName] = []
			}
			onode.outputCallbacks[outPortName].push({
				node: inode,
				port: inPortName
			})
			drawLink(onode, outPortName, inode, inPortName)
		}
	}

	function undrawLink (outNodeName, outPortName, inNodeName, inPortName) {
		// TODO: https://stackoverflow.com/questions/55435098/qml-shape-type-property-data-has-no-method-for-removing-entries
		// TODO: would all problems go away if we use a repeater?
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

		links.data = newdata
		// TODO: removing some lines visually show wrong line removed..
		// TODO: WRKRND2 move the node to update lines...
		let meh = findNodeByName(inNodeName)
		meh.x++
		meh.x--
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
