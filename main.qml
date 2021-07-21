#!/usr/bin/env -S QML_XHR_ALLOW_FILE_READ=1 QML_XHR_ALLOW_FILE_WRITE=1 qml

import QtQuick 2.15
import QtQuick.Layouts 1.15
import "lib" as Lib

Rectangle { id:root
	width: 320
	height: 200
	color: theme.window_bg
	property string filename
	property var theme: ({
		font_family: "monospace",
		font_point: 8,
		window_bg: "#2d2d2d",
		canvas_bg: "#1d1d1d",
		canvas_fg: "white",
		node_bg: "#3d3d3d",
		node_fg: "#0d0d0d",
		port_bg: "transparent",
		port_fg: "#8d8d8d",
		input_bg: "#1d1d1d",
		input_fg: "#7d7d7d",
		button_bg: "#3d3d3d",
		button_fg: "#8d8d8d",
		link_fg: "#4d4d4d",
		antialias: 8,
		line_width: 2,
		line_curve: 20
	})

	FontMetrics {
		id: fsize
		property int w: maximumCharacterWidth
		property int pad: Math.round(w/2)
		font.family: theme.font_family
		font.pointSize: theme.font_point
	}

	RowLayout { id:toolbar
		spacing: fsize.pad
		anchors.topMargin: fsize.pad
		anchors.leftMargin: anchors.topMargin
		anchors.rightMargin: anchors.topMargin
		anchors.bottomMargin: anchors.topMargin
		anchors.top: parent.top
		anchors.left: parent.left
		anchors.right: parent.right
		Lib.Button {
			text: "clear"
			onClicked: canvas.clearPatch()
		}
		Lib.Button {
			text: "load"
			onClicked: loadPatch()
		}
		Lib.Button {
			text: "save"
			onClicked: savePatch()
		}
		Lib.TextInput {
			text: root.filename
			onEdited: root.filename = text
			Layout.fillWidth: true
		}
	}

	Lib.Canvas { id:canvas
		anchors.topMargin: fsize.pad
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
