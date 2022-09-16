import QtQuick 2.15

Rectangle {
    id: root
//    property var showStatusInfo : {
//        return layoutScreen.height >= 480
//    }

    color: "transparent"

    property var showBattery : {
        return true
    }

    property var percent: {
        api.device && api.device.batteryPercent ? api.device.batteryPercent : 1
    }

    BatteryIndicator {
        id: battery_indicator
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
            verticalCenterOffset: vpx(2)
            rightMargin: vpx(12)
        }
        opacity: 0.6
        lightStyle: true
        visible: showBattery
    }

    Text {
        id: battery_percent
        font.family: systemSubitleFont.name
        text: Math.round(percent * 100) + "%"
        anchors {
            right:  battery_indicator.left
            rightMargin: vpx(4)
            verticalCenter: parent.verticalCenter
        }
        color: "#66ffffff"
        font.pixelSize: vpx(24)
        //        font.letterSpacing: -0.3
        //        font.bold: true
        visible: showBattery
    }

    Text {
        id: header_time
        font.family: systemSubitleFont.name
        text: Qt.formatTime(new Date(), "hh:mm")
        anchors {
            right: showBattery ? battery_percent.left : parent.right
            verticalCenter: parent.verticalCenter
            rightMargin: vpx(24)
        }
        color: "#ccffffff"
        font.pixelSize: vpx(24)
        font.letterSpacing: -0.3
//        visible: showStatusInfo
    }
}
