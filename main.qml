#!/usr/bin/env qml

import QtQuick 2.15
import "." as A

Rectangle { id:root
	width: 320
	height: 200
	color: "#4d4d4d"

	A.Banger { id:node1; x:20; y:20 }
	A.Random { id:node2; x:120; y:20 }
	A.NoteOut { id:node3; x:220; y:20 }

	Component.onCompleted: {
		node1.toggleLink("out$bang", node2, "in$bang")
		node1.toggleLink("out$bang", node2, "in$max")
		node2.toggleLink("out$rand", node3, "in$note")
	}
}
