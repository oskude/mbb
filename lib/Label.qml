import QtQuick 2.15
import "." as A

A.Text {
	leftPadding: fsize.pad
	rightPadding: leftPadding
	topPadding: Math.round(fsize.pad/2)
	bottomPadding: topPadding
	color: theme.window_fg
}
