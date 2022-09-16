import QtQuick 2.12
import QtGraphicalEffects 1.12
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.15
Item {
    id: root
    property var title: "Button"
    property var icon: "play"
    property var textColor: "#000000"

    signal clicked()

    Rectangle {
        id: buttonBackground
        anchors.fill: parent
        color: parent.activeFocus ? systemColor : "#ffffff"
        radius: vpx(4)
    }

    DropShadow {
        anchors.fill: buttonBackground
        horizontalOffset: 0
        verticalOffset: 6
        radius: 12.0
        samples: 10
        color: parent.activeFocus ? "#40000000" : "#20000000"
        source: buttonBackground
    }

    Text {
        text: title
        font.bold: false
        font.pixelSize: vpx(16)
        visible: parent.activeFocus
        opacity: 0.5
        color: textColor
        anchors.top: parent.bottom
        anchors.topMargin: vpx(4)
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Image {
        id: iconImage
        source: "../assets/icons/ic-" + icon + ".svg"
        height: parent.height * 0.6
        width: height
        anchors {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }
    }

    ColorOverlay {
        anchors.fill: iconImage
        source: iconImage
        color: parent.activeFocus ? "#ffffff" : systemColor// "#333333"
    }

    TapHandler {
        gesturePolicy: TapHandler.ReleaseWithinBounds
        onTapped: root.clicked()
    }
}
