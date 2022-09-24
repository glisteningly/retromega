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
            return currentHomeIndex <= 1 ?  "#22000000" : theme.background
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
        height: parent.height
        width: parent.height
        color:"#33000000"
        anchors.left: parent.left

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
        anchors.leftMargin: vpx(24)
        lightText: light
//        KeyNavigation.down: mainFocus
//        KeyNavigation.right: title_collection
        onClicked: setHomeIndex(0)
    }

    HeaderLink {
        id: title_collection
        title: curDataText.home_collection
        icon: "collections"
        index: 1
        anchors.left: title_systems.right
        anchors.top: parent.top
        lightText: light
//        KeyNavigation.down: mainFocus
//        KeyNavigation.right: title_favorites
        onClicked: setHomeIndex(1)
    }

    HeaderLink {
        id: title_favorites
        title: curDataText.home_favorite
        icon: "favorites"
        index: 2
        anchors.left: title_collection.right
        anchors.top: parent.top
        lightText: light
//        KeyNavigation.down: mainFocus
//        KeyNavigation.right: title_recent
        onClicked: setHomeIndex(2)
    }

    HeaderLink {
        id: title_recent
        title: curDataText.home_recent
        icon: "recent"
        index: 3
        anchors.left: title_favorites.right
        anchors.top: parent.top
        lightText: light
//        KeyNavigation.down: mainFocus
        onClicked: setHomeIndex(3)
    }

    Rectangle {
        id: tabRight
        height: parent.height
        width: parent.height
        color:"#33000000"

        anchors {
            left: title_recent.right
            leftMargin: vpx(24)
        }
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
        id: headInfoHome
        height: parent.height
        anchors {
            right: parent.right
        }
    }

    property bool showColumsCtrl: {
        if (currentHomeIndex === 0 || currentHomeIndex === 1) {
            return currentSystemViewMode === 'grid'
        } else if (currentHomeIndex === 2 || currentHomeIndex === 3) {
            return currentGameListViewMode === 'grid'
        } else {
            return false
        }
    }

    function columnCtrlDec() {
        if (currentHomeIndex === 0) {
            setSystemColumnsDec()
        } else if (currentHomeIndex === 1) {
            setCollectionColumnsDec()
        } else if (currentHomeIndex === 2 || currentHomeIndex === 3) {
            setGamelistColumnsDec()
        }
    }

    function columnCtrlInc() {
        if (currentHomeIndex === 0) {
            setSystemColumnsInc()
        } else if (currentHomeIndex === 1) {
            setCollectionColumnsInc()
        } else if (currentHomeIndex === 2 || currentHomeIndex === 3) {
            setGamelistColumnsInc()
        }
    }

    Item {
        id: viewCtrl
        height: parent.height
        width: parent.height + vpx(4)
        anchors {
            right: parent.right
            rightMargin: vpx(200)
        }
        Item {
            visible: (currentHomeIndex === 0 || currentHomeIndex === 1)
            width: parent.height
            anchors {
                top: parent.top
                right: parent.right
                bottom: parent.bottom
            }
            TapButton {
                iconSize: vpx(32)
                iconImage: currentSystemViewMode === 'list' ? "../assets/icons/ic-view-grid.svg" : "../assets/icons/ic-view-card.svg"
                bgColor: "#22000000"
                iconOpacity: 0.6
                onClicked: toggleSystemViewMode()
            }
        }
        Item {
            visible: (currentHomeIndex === 2 || currentHomeIndex === 3)
            width: parent.height
            anchors {
                top: parent.top
                right: parent.right
                bottom: parent.bottom
            }
            TapButton {
                iconSize: vpx(32)
                iconImage: currentGameListViewMode === 'list' ? "../assets/icons/ic-view-grid.svg" : "../assets/icons/ic-view-list.svg"
                bgColor: "#22000000"
                iconOpacity: 0.6
                onClicked: toggleGameListViewMode()
            }
        }
    }

    Item {
        id: columsCtrl
        visible: showColumsCtrl
        height: parent.height
        anchors {
            right: viewCtrl.left
            rightMargin: vpx(24)
        }
        Item {
            id: columnDec
            width: parent.height
            anchors {
                top: parent.top
                right: parent.right
                bottom: parent.bottom
            }
            TapButton {
                iconSize: vpx(32)
                iconImage: "../assets/icons/ic-grid-dec.svg"
                bgColor: "#22000000"
                iconOpacity: 0.6
                onClicked: columnCtrlDec()
            }
        }
        Item {
            id: columnInc
            width: parent.height
            anchors {
                top: parent.top
                right: columnDec.left
                rightMargin: vpx(4)
                bottom: parent.bottom
            }
            TapButton {
                iconSize: vpx(32)
                iconImage: "../assets/icons/ic-grid-inc.svg"
                bgColor: "#22000000"
                iconOpacity: 0.6
                onClicked: columnCtrlInc()
            }
        }
    }
}
