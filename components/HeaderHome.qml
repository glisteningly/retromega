import QtQuick 2.12

Rectangle {
    property var focused_link: {
        if (currentHomeIndex == 0) {
            return title_systems
        } else if (currentHomeIndex == 1) {
            return title_collection
        } else if (currentHomeIndex == 2) {
            return title_favorites
        } else if (currentHomeIndex == 3) {
            return title_recent
        }
    }

    property var focused_title: {
        if (currentHomeIndex == 0) {
            return 'systems'
        } else if (currentHomeIndex == 1) {
            return 'collection'
        } else if (currentHomeIndex == 2) {
            return 'favorites'
        } else if (currentHomeIndex == 3) {
            return 'recent'
        }
    }


    onFocused_titleChanged: {
        home_header.state = focused_title
    }

    property var anyFocused: {
        return title_systems.activeFocus || title_collection.activeFocus ||title_favorites.activeFocus || title_recent.activeFocus
    }

    property bool light: false

    property var showStatusInfo : {
        return layoutScreen.height >= 480
    }

    property var showBattery : {
        return true
        //        return showStatusInfo && (api.device !== null && api.device.batteryPercent)
    }

    property var percent: {
        api.device && api.device.batteryPercent ? api.device.batteryPercent : 1
    }

    id: home_header
    color: {
        if (currentSystemViewMode === 'grid') {
            return theme.background
        } else {
            return currentHomeIndex <= 1 ?  "#11000000" : theme.background
        }
    }
    //    width: parent.width

    height: layoutHeader.height
    anchors {
        top: parent.top
        left: parent.left
        right: parent.right
    }

    Rectangle{
        id: tabLeft
        //        height:parent.height
        width:40
        color:"#33000000"
        radius:2
        anchors.top: parent.top
        anchors.topMargin: vpx(4)
        anchors.left: parent.left
        anchors.leftMargin: vpx(4)
        anchors.bottom: parent.bottom
        anchors.bottomMargin: vpx(4)
        //        border {
        //            color: "#888"
        //            width: 1
        //        }

        Text{
            text: "L"
            color:"#55EEEEEE"
            font.pixelSize: vpx(20)
            //            font.letterSpacing: -0.3
            font.bold: true
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    Item {
        id: indicator
        width: focused_link.width
        height: parent.height

        Rectangle {
            id: bg
            color: "#22000000"
            anchors {
                fill: parent
            }
        }

        Rectangle {
            height: vpx(2)
            //            color: "#CCC"
            color: theme.primaryColor
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                //                bottomMargin: 1
            }
        }
    }

    states: [
        State {
            name: 'systems'
            AnchorChanges { target: indicator; anchors.left: title_systems.left }
        },
        State {
            name: 'collection'
            AnchorChanges { target: indicator; anchors.left: title_collection.left }
        },
        State {
            name: 'favorites'
            AnchorChanges { target: indicator; anchors.left: title_favorites.left }
        },
        State {
            name: 'recent'
            AnchorChanges { target: indicator; anchors.left: title_recent.left }
        }
    ]

    transitions: Transition {
        // smoothly reanchor myRect and move into new position
        AnchorAnimation { duration: 200; easing.type: Easing.InOutCubic }
    }

    HeaderLink {
        id: title_systems
        title: curDataText.home_system
        icon: "system"
        index: 0
        anchors.left: tabLeft.right
        anchors.top: parent.top
        //        anchors.topMargin: 6
        anchors.leftMargin: vpx(12)
        lightText: light
        KeyNavigation.down: mainFocus
        KeyNavigation.right: title_collection
    }

    HeaderLink {
        id: title_collection
        title: curDataText.home_collection
        icon: "collections"
        index: 1
        anchors.left: title_systems.right
        anchors.top: parent.top
        //        anchors.topMargin: 6
        //        anchors.leftMargin: 24
        lightText: light
        KeyNavigation.down: mainFocus
        KeyNavigation.right: title_favorites
    }

    HeaderLink {
        id: title_favorites
        title: curDataText.home_favorite
        icon: "favorites"
        index: 2
        anchors.left: title_collection.right
        anchors.top: parent.top
        //        anchors.topMargin: 6
        //        anchors.leftMargin: 24
        lightText: light
        KeyNavigation.down: mainFocus
        KeyNavigation.right: title_recent
    }

    HeaderLink {
        id: title_recent
        title: curDataText.home_recent
        icon: "recent"
        index: 3
        anchors.left: title_favorites.right
        anchors.top: parent.top
        //        anchors.topMargin: 6
        //        anchors.leftMargin: 24
        lightText: light
        KeyNavigation.down: mainFocus
        //        KeyNavigation.right: title_apps
    }

    Rectangle {
        id: tabRight
        //        height:18
        width:40
        color:"#33000000"
        radius:2

        anchors {
            top: parent.top
            topMargin: vpx(4)
            left: title_recent.right
            leftMargin: vpx(12)
            bottom: parent.bottom
            bottomMargin: vpx(4)
        }

        //        border {
        //            color: "#888"
        //            width: 1
        //        }
        Text{
            text: "R"
            color:"#55EEEEEE"
            font.pixelSize: vpx(20)
            //            font.letterSpacing: -0.3
            font.bold: true
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    HeaderInfoBar {
        height: parent.height
        anchors {
            right: parent.right
        }
    }

    //    HeaderLink {
    //        id: title_apps
    //        title: "应用"
    //        index: 3
    //        anchors.left: title_recent.right
    //        anchors.top: parent.top
    //        anchors.topMargin: 6
    //        anchors.leftMargin: 24
    //        lightText: light
    //        KeyNavigation.down: mainFocus
    //    }

    //    BatteryIndicator {
    //        id: battery_indicator
    //        anchors {
    //            right: parent.right
    //            verticalCenter: parent.verticalCenter
    //            verticalCenterOffset: vpx(2)
    //            rightMargin: vpx(12)
    //        }
    //        opacity: 0.6
    //        lightStyle: true
    //        visible: showBattery
    //    }

    //    Text {
    //        id: battery_percent
    //        font.family: systemSubitleFont.name
    //        text: Math.round(percent * 100) + "%"
    //        anchors {
    //            right:  battery_indicator.left
    //            verticalCenter: parent.verticalCenter
    //        }
    //        color: "#66ffffff"
    //        font.pixelSize: vpx(24)
    //        //        font.letterSpacing: -0.3
    //        //        font.bold: true
    //        visible: showBattery
    //    }

    //    Text {
    //        id: header_time
    //        font.family: systemSubitleFont.name
    //        text: Qt.formatTime(new Date(), "hh:mm")
    //        anchors {
    //            right: showBattery ? battery_percent.left : parent.right
    //            verticalCenter: parent.verticalCenter
    //            rightMargin: vpx(24)
    //        }
    //        color: "#ccffffff"
    //        font.pixelSize: vpx(24)
    //        font.letterSpacing: -0.3
    //        visible: showStatusInfo
    //    }

}
