import QtQuick 2.12
import QtGraphicalEffects 1.12

Item {
    property var tintColor : theme.primaryColor

	// DropShadow {
	// 	anchors.fill: list_selection
	// 	horizontalOffset: 0
	// 	verticalOffset: 4
	// 	radius: 12.0
	// 	samples: 18
	// 	opacity: 0.4
	// 	color: "#30000000"
	// 	source: list_selection
	// }

	/** Selection Rect */
	Rectangle{
		id: list_selection
        width: parent.width + 12
        height: parent.height - 10
		color: tintColor
        opacity: 1
        x: -10
        y: 6
        radius: 6
	}
}
