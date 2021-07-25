.pragma library

function Timer (root) {
	return Qt.createQmlObject("import QtQuick 2.15; Timer {}", root)
}

function delayFunc (root, time, func) {
	let timer = new Timer(root)
	timer.interval = time
	timer.repeat = false
	timer.triggered.connect(func)
	timer.triggered.connect(function clr () {
		timer.triggered.disconnect(func)
		timer.triggered.disconnect(clr)
		timer.destroy()
	})
	timer.start()
}

function delaySendMsg (root, port, time, msg) {
	delayFunc(root, time, function(){
		port.sendMessage(msg[0], msg[1], msg[2])
	})
}
