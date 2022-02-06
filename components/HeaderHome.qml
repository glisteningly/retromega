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

    property var anyFocused: {
        return title_systems.activeFocus || title_collection.activeFocus ||title_favorites.activeFocus || title_recent.activeFocus
    }

    property var light: false

    property var showStatusInfo : {
        return layoutScreen.height >= 480
    }

    property var showBattery : {
        return showStatusInfo && (api.device != null && api.device.batteryPercent)
    }

    id: home_header
    color: "transparent"
    width: parent.width
    height: layoutHeader.height
    anchors.top: parent.top      

    Rectangle {
        anchors.leftMargin: 22
        anchors.rightMargin: 22
        anchors.left: parent.left
        anchors.right: parent.right
        color: light ? "#00ffffff" : "#20000000"
        anchors.bottom: parent.bottom
        height: 1
    }

    Rectangle{
        id: tabLeft
        height:18
        width:32
        color:"#80444444"
        radius:2
        anchors.top: parent.top
        anchors.topMargin: 11
        //anchors.right: header_time.left
        anchors.left: parent.left
        anchors.leftMargin: 24
        //anchors.rightMargin: 5
//        anchors.rightMargin: 32
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

    HeaderLink {
        id: title_systems
        title: "机种"
        index: 0
        anchors.left: tabLeft.right
        anchors.top: parent.top
        anchors.topMargin: 6
        anchors.leftMargin: 16
        lightText: light
        KeyNavigation.down: mainFocus
        KeyNavigation.right: title_collection
    }

    HeaderLink {
        id: title_collection
        title: "系列"
        index: 1
        anchors.left: title_systems.right
        anchors.top: parent.top
        anchors.topMargin: 6
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
        anchors.topMargin: 6
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
        anchors.topMargin: 6
        anchors.leftMargin: 24
        lightText: light
        KeyNavigation.down: mainFocus     
//        KeyNavigation.right: title_apps
    }

    Rectangle{
        id: tabRight
        height:18
        width:32
        color:"#80444444"
        radius:2
        anchors.top: parent.top
        anchors.topMargin: 11
        //anchors.right: header_time.left
        anchors.left: title_recent.right
        anchors.leftMargin: 16
        //anchors.rightMargin: 5
//        anchors.rightMargin: 32
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
        opacity: 0.5
        lightStyle: light
        visible: showBattery 
    }

    Text {
        id: header_time
        text: Qt.formatTime(new Date(), "hh:mm")          
        anchors.right:  parent.right
        anchors.top: parent.top
        anchors.topMargin: 8
        anchors.rightMargin: showBattery ? 54 : 16
        color: light ? "#60ffffff" : "#60000000"
        font.pixelSize: 18
        font.letterSpacing: -0.3
        font.bold: true     
        visible: showStatusInfo         
    }      

}
