import QtQuick 2.15
import "." as A

Rectangle { id: root
	property alias text: txtin.text
	signal edited ()
	height: txtin.height
	color: theme.input_bg
	TextInput { id:txtin
		width: parent.width
		font.family: theme.font_family
		font.pointSize: theme.font_point
		color: theme.input_fg
		selectedTextColor: theme.input_sel_fg
		selectionColor: theme.input_sel_bg
		leftPadding: fsize.pad
		rightPadding: leftPadding
		topPadding: Math.round(fsize.pad/2)
		bottomPadding: topPadding
		selectByMouse: true
		onEditingFinished: {
			root.edited()
			focus = false
		}
	}
}
