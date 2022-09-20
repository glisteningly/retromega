import QtQuick 2.12
import QtGraphicalEffects 1.12
//import QtQuick.Controls 2.15

ListView {
    id: systemsListView

    property var footerTitle: {
        return (currentIndex + 1) + " / " + allSystems.count
    }

    function titleFontSize(str) {
        return str.length <= 10 ? vpx(100) : vpx(80)
    }

    property int bgIndex: 0
    //    property var itemTextColor: {
    //        systemsListView.activeFocus ? #ffffff"  : "#30ffffff"
    //    }
    property string itemTextColor: "#ffffff"

    currentIndex: currentSystemIndex
    width: parent.width
    anchors {
        verticalCenter: parent.verticalCenter
        left: parent.left
        right: parent.right
        bottom: parent.bottom
    }

    model: allSystems
    cacheBuffer: 10
    delegate: systemsDelegate
    orientation: ListView.Horizontal
    highlightRangeMode: ListView.StrictlyEnforceRange
    preferredHighlightBegin: 0
    preferredHighlightEnd: 320 + 220
    snapMode: ListView.SnapToItem
    highlightMoveDuration: 325
    highlightMoveVelocity: -1
    keyNavigationWraps: false
    spacing: 50
    move: Transition {
        NumberAnimation { properties: "x,y"; duration: 3000 }
    }
    displaced: Transition {
        NumberAnimation { properties: "x,y"; duration: 3000 }
    }
    Keys.onLeftPressed: {
        decrementCurrentIndex(); systemsBackground.bgIndex = currentIndex
    }

    Keys.onRightPressed: {
        incrementCurrentIndex(); systemsBackground.bgIndex = currentIndex
    }

    Keys.onPressed: {
        //Next page
        if (api.keys.isPageDown(event)) {
            event.accepted = true
            systemsListView.currentIndex = Math.min(systemsListView.currentIndex + 10, allSystems.count - 1)
            systemsBackground.bgIndex = currentIndex
            return
        }

        //Prev collection
        if (api.keys.isPageUp(event)) {
            event.accepted = true;
            systemsListView.currentIndex = Math.max(systemsListView.currentIndex - 10, 0);
            systemsBackground.bgIndex = currentIndex
            return;
        }

        event.accepted = false
    }

    Timer {
        id: timer
    }

    function delay(delayTime, cb) {
        timer.interval = delayTime;
        timer.repeat = false;
        timer.triggered.connect(cb);
        timer.start();
    }


    PageIndicator {
        currentIndex: systemsListView.currentIndex
        pageCount: allSystems.count
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 25
        opacity: 1.0
    }

    Rectangle {
        property int bgIndex: -1
        id: systemsBackground
        width: layoutScreen.width
        height: layoutScreen.height
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: vpx(-50)
        z: -1
        color: theme.background_dark
        Behavior on bgIndex {
            ColorAnimation {
                target: systemsBackground; property: "color"; to: systemInfoList[allSystems.get(currentIndex).shortName].color || systemInfoList["default"].color; duration: 335
            }
        }
        transitions: Transition {
            ColorAnimation { properties: "color"; easing.type: Easing.InOutQuad ; duration: 335 }
        }
    }

    Component.onDestruction: {
        setSystemIndex(systemsListView.currentIndex)
    }

    Component.onCompleted: {
        positionViewAtIndex(currentSystemIndex, ListView.Center)
        delay(200, function() {
            systemsListView.positionViewAtIndex(currentSystemIndex, ListView.Center)
            systemsBackground.bgIndex = currentIndex
        })
    }

    onVisibleChanged: {
        if (visible) {
            positionViewAtIndex(currentSystemIndex, ListView.Center)
            delay(50, function() {
                systemsListView.positionViewAtIndex(currentSystemIndex, ListView.Center)
                systemsBackground.bgIndex = currentIndex
            })
        }
    }

    onCurrentIndexChanged: {
        if (visible) {
            navSound.play()
            setCurSystemIndex(currentIndex)
        }
    }

    //    onEnabledChanged: {
    //        console.log("ENABLED: " + enabled);
    //    }

    Component {
        id: systemsDelegate


        Item {
            id: system_listitem_container
            width: layoutScreen.width
            height: layoutScreen.height
            scale: 1.0
            
            z: 100 - index
            Keys.onPressed: {
                if (api.keys.isAccept(event)) {
                    event.accepted = true;
                    
                    //We update the collection we want to browse
                    setCollectionListIndex(0)
                    setSystemIndex(system_listitem_container.ListView.view.currentIndex)

                    //We change Pages
                    navigate('GamesPage');
                    
                    return;
                }
                //                if (api.keys.isFilters(event)) {
                //                    event.accepted = true;
                //                    toggleZoom();
                //                    return;
                //                }
            }


            Rectangle {
                id: systemsListView_item
                width: parent.width
                height: parent.height
                color:  "transparent"
                
                Image {
                    id: menu_mask
                    height: layoutScreen.height
                    anchors {
                        fill: parent
                    }
                    fillMode: Image.PreserveAspectCrop
                    z: 0
                    source: "../assets/images/bg_system_line.png"
                }
                
                Image {
                    id: device
                    //                    source: "../assets/images/devices/"+modelData.shortName+".png"
                    source: "../assets/images/hardware/"+modelData.shortName+".png"
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: -vpx(40)
                    anchors.verticalCenterOffset: -vpx(30)
                    cache: true
                    asynchronous: true
                    width: vpx(800)
                    height: vpx(800)
                    fillMode: Image.PreserveAspectFit
//                    scale: 1.0
                    scale: systemInfoList[modelData.shortName].thumb_scale ? 0.8 : 1.0
                    states: [

                        State{
                            name: "inactiveRight"; when: !(system_listitem_container.ListView.isCurrentItem) && currentIndex < index
                            PropertyChanges { target: device; anchors.rightMargin: -vpx(160); opacity: 1.0}
                        },

                        State{
                            name: "inactiveLeft"; when: !(system_listitem_container.ListView.isCurrentItem) && currentIndex > index
                            PropertyChanges { target: device; anchors.rightMargin: vpx(40); opacity: 1.0}
                        },

                        State {
                            name: "active"; when: system_listitem_container.ListView.isCurrentItem
                            PropertyChanges { target: device; anchors.rightMargin: -vpx(40); opacity: 1.0;}
                        },

                        State {
                            name: "inactive"; when: system_listitem_container.ListView.isCurrentItem
                            PropertyChanges { target: device; anchors.rightMargin: -vpx(40); opacity: 1.0;}
                        }
                    ]

                    transitions: Transition {
                        NumberAnimation { properties: "scale, opacity, anchors.rightMargin"; easing.type: Easing.InOutCubic; duration: 225  }
                    }
                    
                }

                //              主标题
                Text {
                    id: title
                    text: modelData.name
                    font.family: systemTitleFont.name
                    font.pixelSize: titleFontSize(modelData.name)
                    font.letterSpacing: 0
                    //                    font.bold: true
                    color: itemTextColor
                    //                    width: 280
                    wrapMode: Text.WordWrap
                    //                    anchors.rightMargin: 30
                    visible: true
                    lineHeight: 0.8
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: vpx(60)
                    anchors.verticalCenterOffset: vpx(15)
                }

                DropShadow {
                    anchors.fill: title
                    source: title
                    verticalOffset: 2
                    horizontalOffset: 2
                    color: "#60000000"
                    radius: 5
                    //                    samples: 10
                }
                
                Text {
                    text: modelData.games.count + " " + dataText[lang].global_games
                    font {
                        family: boldTitleFont
                        pixelSize: vpx(28)
                        letterSpacing: -0.3
                    }

                    //                    font.bold: true
                    color: itemTextColor
                    opacity: 0.7
                    anchors.topMargin: vpx(8)
                    anchors.left: title.left
                    anchors.leftMargin: vpx(2)
                    anchors.top: title.bottom
                    visible: true
                }

                Text {
                    text: systemInfoList[modelData.shortName].company.toUpperCase()
                    font.family: systemSubitleFont.name
                    font.pixelSize: vpx(20)
                    font.letterSpacing: 0.5
                    //                    font.bold: true
                    color: itemTextColor
                    opacity: 0.7
                    anchors.bottomMargin: -1
                    anchors.left: title.left
                    anchors.leftMargin: vpx(2)
                    anchors.bottom: title.top
                }

                Rectangle {
                    id: selectButton
                    visible: false
                    width: 64
                    height: 28
                    color: systemsListView.activeFocus ? "#000000"  : "#20ffffff"
                    anchors.topMargin: 12
                    radius: 8
                    anchors.top: title.bottom
                    anchors.left: title.left

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "View"
                        font.pixelSize: 12
                        font.letterSpacing: 0
                        font.bold: true
                        color: systemsListView.activeFocus ? "#ffffff"  : "#ffffff"
                    }
                }

                // Image {
                //     id: tile_logo
                //     source: "../assets/images/logos/"+modelData.shortName+".png"
                //     anchors.verticalCenter: parent.verticalCenter
                //     anchors.horizontalCenter: parent.horizontalCenter
                // }
            }

            Text {
                id: subtitle
                text: modelData.name
                //anchors.bottom: parent.bottom
                //anchors.bottomMargin: -30
                font.pixelSize: 14
                font.letterSpacing: -0.3
                font.bold: true
                color: "#4F4F4F"
                visible: false
            }

            Text {
                text: modelData.games.count + " games"
                //anchors.bottom: parent.bottom
                //anchors.bottomMargin: 20
                font.pixelSize: 14
                font.letterSpacing: -0.3
                font.bold: true
                color: "#ffffff"
                opacity: 0.7
                visible: false
                //anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.bottomMargin: -30
            }
            
            // DropShadow {
            //     anchors.fill: systems__item
            //     horizontalOffset: 3
            //     verticalOffset: 3
            //     radius: 8.0
            //     samples: 17
            //     color: "#80000000"
            //     source: systems__item
            // }

        }
    }
    

}
