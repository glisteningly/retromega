import QtQuick 2.15
Rectangle {
    id: root
    signal clicked()

    property var iconSize: vpx(24)
    property string iconImage: ''
    property real iconOpacity: 1
    property string bgColor: '#333'


    anchors {
        fill: parent
    }
    color: bgColor

    Image {
        width: iconSize
        height: iconSize
        source: iconImage
        anchors {
            centerIn: parent
        }
        opacity: iconOpacity
    }

    Rectangle {
        anchors.fill: parent
        color: tapArea.pressed? "#11FFFFFF" : "transparent"
    }

    TapHandler {
        id: tapArea
        gesturePolicy: TapHandler.ReleaseWithinBounds
        onTapped: clicked()
    }
}
