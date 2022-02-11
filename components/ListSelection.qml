import QtQuick 2.12
import QtGraphicalEffects 1.12

Item {
    property var tintColor : "#66333333"

//     DropShadow {
//        anchors.fill: list_selection
//        horizontalOffset: 0
//        verticalOffset: 2
//        radius: 5.0
//        samples: 7
//        opacity: 0.8
//        color: "#60000000"
//        source: list_selection
//     }

	/** Selection Rect */
	Rectangle{
		id: list_selection
		width:parent.width + 12
        height:parent.height - 4
		color: tintColor
		opacity:1
        x: -10
        y: 3
        radius: 6
	}

}
