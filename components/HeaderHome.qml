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

    id: home_header
    color: {
         if (currentSystemViewMode === 'grid') {
             return theme.background
         } else {
             return currentHomeIndex <= 1 ?  "transparent" : theme.background
         }
    }
    width: parent.width
    height: layoutHeader.height
    anchors.top: parent.top      

    Rectangle{
        id: tabLeft
        height:18
        width:32
        color:"#444444"
        radius:2
        anchors.top: parent.top
        anchors.topMargin: 11
        anchors.left: parent.left
        anchors.leftMargin: 24
        border {
            color: "#888"
            width: 1
        }

        Text{
            text: "L"
            color:"white"
            font.pixelSize: 12
//            font.letterSpacing: -0.3
            font.bold: true
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    Rectangle {
        id: indicator
        width: focused_link.width + 12
        height: 4
        color: theme.primaryColor
        anchors {
            leftMargin: -6
            bottom: parent.bottom
            bottomMargin: 1
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
            AnchorAnimation { duration: 200 }
    }

    HeaderLink {
        id: title_systems
        title: "机型"
        index: 0
        anchors.left: tabLeft.right
        anchors.top: parent.top
//        anchors.topMargin: 6
        anchors.leftMargin: 16
        lightText: light
        KeyNavigation.down: mainFocus
        KeyNavigation.right: title_collection
    }

    HeaderLink {
        id: title_collection
        title: "合集"
        index: 1
        anchors.left: title_systems.right
        anchors.top: parent.top
//        anchors.topMargin: 6
        anchors.leftMargin: 24
        lightText: light
        KeyNavigation.down: mainFocus
        KeyNavigation.right: title_favorites
    }

    HeaderLink {
        id: title_favorites
        title: "收藏"
        index: 2
        anchors.left: title_collection.right
        anchors.top: parent.top
//        anchors.topMargin: 6
        anchors.leftMargin: 24
        lightText: light
        KeyNavigation.down: mainFocus    
        KeyNavigation.right: title_recent           
    }

    HeaderLink {
        id: title_recent
        title: "最近"
        index: 3
        anchors.left: title_favorites.right
        anchors.top: parent.top
//        anchors.topMargin: 6
        anchors.leftMargin: 24
        lightText: light
        KeyNavigation.down: mainFocus     
//        KeyNavigation.right: title_apps
    }

    Rectangle{
        id: tabRight
        height:18
        width:32
        color:"#444444"
        radius:2
        anchors.top: parent.top
        anchors.topMargin: 11
        anchors.left: title_recent.right
        anchors.leftMargin: 16
        border {
            color: "#888"
            width: 1
        }
        Text{
            text: "R"
            color:"white"
            font.pixelSize: 12
//            font.letterSpacing: -0.3
            font.bold: true
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
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
    
    BatteryIndicator {
        id: battery_indicator
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 12
        anchors.rightMargin: 16
        opacity: 0.6
        lightStyle: light
        visible: showBattery 
    }

    Text {
        id: header_time
        font.family: systemSubitleFont.name
        text: Qt.formatTime(new Date(), "hh:mm")          
        anchors.right:  parent.right
        anchors.top: parent.top
        anchors.topMargin: 8
        anchors.rightMargin: showBattery ? 54 : 16
        color: light ? "#ccffffff" : "#80000000"
        font.pixelSize: 18
        font.letterSpacing: -0.3
//        font.bold: true
        visible: showStatusInfo         
    }      

}
