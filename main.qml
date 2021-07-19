#!/usr/bin/env -S QML_XHR_ALLOW_FILE_READ=1 QML_XHR_ALLOW_FILE_WRITE=1 qml

import QtQuick 2.15
import QtQuick.Layouts 1.15
import "." as A

Rectangle { id:root
	width: 320
	height: 200
	color: "#4d4d4d"
	property string filename

	RowLayout { id:toolbar
		spacing: 8
		anchors.left: parent.left
		anchors.right: parent.right
		A.Button {
			text: "clear"
			onClicked: canvas.clearPatch()
		}
		A.Button {
			text: "load"
			onClicked: loadPatch()
		}
		A.Button {
			text: "save"
			onClicked: savePatch()
		}
		A.TextInput {
			text: root.filename
			onEdited: root.filename = text
			Layout.fillWidth: true
		}
	}

	A.Canvas { id:canvas
		anchors.top: toolbar.bottom
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.bottom: parent.bottom
	}

	Component.onCompleted: {
		let args = Qt.application.arguments.slice(2)
		if (args[0] == "--") args = args.slice(1)
		if (args[0]) {
			filename = args[0]
			loadPatch()
		}
	}

	function loadPatch () {
		if (!filename) return
		try {
			let file = readFile(filename)
			canvas.importPatch(file)
		} catch (e) {
			console.log("ERROR READING FILE:", filename, e)
		}
	}

	function savePatch () {
		if (!filename) return
		let patch = canvas.exportPatch()
		try {
			writeFile(filename, patch)
		} catch (e) {
			console.log("ERROR WRITING FILE:", filename, e)
		}
	}

	// yeah, these are the only ways to read/write files in qml...

	function readFile (path) {
		let req = new XMLHttpRequest()
		req.open("GET", path, false)
		req.send(null)
		if (req.status !== 200)
			throw "file not found" // yeah, we're just assuming...
		return req.responseText
	}

	function writeFile (path, text) {
		let req = new XMLHttpRequest()
		req.open("PUT", path, false)
		req.send(text)
		// NOTE: looks like there is no way to tell status of write...
		return req.status
	}
}
