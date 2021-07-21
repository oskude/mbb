import QtQuick 2.15
import QtQuick.Shapes 1.15

ShapePath {
	id: root
	property int curve: theme.line_curve
	property alias endX: path.x
	property alias endY: path.y
	property var link: []
	fillColor: "transparent"
	strokeColor: theme.link_fg
	strokeWidth: theme.line_width
	capStyle: ShapePath.FlatCap
	PathCubic {
		id: path
		control1X: root.startX + root.curve
		control1Y: root.startY
		control2X: x - root.curve
		control2Y: y
	}
}
