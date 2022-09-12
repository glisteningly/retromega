import QtQuick 2.12
import QtGraphicalEffects 1.12
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.15
Item {
    width: 26
    height: 14

    property bool lightStyle : false

    property var percent: {
        api.device && api.device.batteryPercent ? api.device.batteryPercent : 1
    }

    //    Image {
    //        id: iconImage
    //        source: lightStyle ? "../assets/images/battery.png" : "../assets/images/battery-dark.png"
    //        anchors.verticalCenter: parent.verticalCenter
    //        anchors.horizontalCenter: parent.horizontalCenter
    //    }

    Rectangle {
        id: container
        anchors {
            centerIn: parent
//            verticalCenterOffset:
        }
        color: "transparent"
        width: vpx(14)
        height: vpx(20)
        border {
            color: "#ffffff"
            width: vpx(2)
        }
    }

    Rectangle {
        anchors {
            bottom: container.top
            horizontalCenter: container.horizontalCenter
//            verticalCenterOffset:
        }
        color: "#ffffff"
        width: vpx(6)
        height: vpx(2)
    }
    
    Rectangle {
        anchors {
            bottom: container.bottom
            left: container.left
            leftMargin: vpx(2)
            bottomMargin: vpx(2)
        }
        color: "#ffffff"
//        radius: 2
//        width: Math.max(percent * 17.6, 2)
        width: container.width - vpx(4)
        height: vpx(Math.max(percent * 16, 2))
    }
}
