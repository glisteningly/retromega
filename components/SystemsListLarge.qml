import QtQuick 2.12
import QtGraphicalEffects 1.12
//import QtQuick.Controls 2.15

ListView {
    id: systemsListView

    property var footerTitle: {
        return (currentIndex + 1) + " / " + allSystems.count
    }

    function titleFontSize(str) {
        return str.length <= 10 ? 70 : 50
    }

    property int bgIndex: 0
//    property var itemTextColor: {
//        systemsListView.activeFocus ? "#ffffff"  : "#30ffffff"
//    }
    property string itemTextColor: "#ffffff"

    currentIndex: currentSystemIndex
    width: parent.width
    anchors.verticalCenter: parent.verticalCenter
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
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
        anchors.topMargin: -55
        z: -1
        Behavior on bgIndex {
            ColorAnimation {
                target: systemsBackground; property: "color"; to: systemColors[allSystems.get(currentIndex).shortName] ?? systemColors["default"]; duration: 335
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
//        positionViewAtIndex(currentSystemIndex, ListView.Center)
        delay(50, function() {
            systemsListView.positionViewAtIndex(currentSystemIndex, ListView.Center)
        })
        systemsBackground.bgIndex = currentIndex
    }

    onVisibleChanged: {
        if (visible) {
            positionViewAtIndex(currentSystemIndex, ListView.Center)
            delay(0, function() {
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
            id: home_item_container
            width: layoutScreen.width
            height: layoutScreen.height - 55 - 55 - 35
            scale: 1.0
            
            z: 100 - index
            Keys.onPressed: {
                if (api.keys.isAccept(event)) {
                    event.accepted = true;
                    
                    //We update the collection we want to browse
                    setCollectionListIndex(0)
                    setSystemIndex(home_item_container.ListView.view.currentIndex)

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
                color:  "transparent" //systemColors[modelData.shortName]  
                
                Image {
                    id: menu_mask
                    //width: 136
                    width: layoutScreen.height * 0.283333
                    height: layoutScreen.height
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.leftMargin: 0
                    anchors.topMargin: -55
                    anchors.rightMargin: 70
                    z: 0
                    source: "../assets/images/menu-side-2.png"
                }

                Rectangle {

                    id: tile_content
                    anchors.top: systemsListView_item.top
                    anchors.left: systemsListView_item.left
                    anchors.topMargin: 0
                    anchors.leftMargin: 0
                    width: parent.width
                    height: parent.height
                    color: systemColors[modelData.shortName] ?? "#000000"
                    clip: false
                    visible: false
                                                                                       
                }                
                    
//                DropShadow {
//                    anchors.fill: mask
//                    horizontalOffset: 0
//                    verticalOffset: 4
//                    radius: 12.0
//                    samples: 16
//                    opacity: 0.4
//                    color: systemColors[modelData.shortName]
//                    source: mask
//                }
                
                Image {
                    id: device
//                    source: "../assets/images/devices/"+modelData.shortName+".png"
                    source: "../assets/images/logos-l/"+modelData.shortName+".png"
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: 0
                    anchors.verticalCenterOffset: 25
                    cache: true
                    asynchronous: true
//                    width: 420
//                    height: 342
                    fillMode: Image.PreserveAspectFit
                    scale: 1.0
                    states: [

                        State{
                            name: "inactiveRight"; when: !(home_item_container.ListView.isCurrentItem) && currentIndex < index
                            PropertyChanges { target: device; anchors.rightMargin: -160.0; opacity: 1.0}
                        },

                        State{
                            name: "inactiveLeft"; when: !(home_item_container.ListView.isCurrentItem) && currentIndex > index
                            PropertyChanges { target: device; anchors.rightMargin: 40.0; opacity: 1.0}
                        },

                        State {
                            name: "active"; when: home_item_container.ListView.isCurrentItem
                            PropertyChanges { target: device; anchors.rightMargin: -10.0; opacity: 1.0; scale: 1.0}
                        },

                        State {
                            name: "inactive"; when: home_item_container.ListView.isCurrentItem
                            PropertyChanges { target: device; anchors.rightMargin: -10.0; opacity: 1.0; scale: 0.85}
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
                    width: 280
                    wrapMode: Text.WordWrap
                    anchors.rightMargin: 30
                    visible: true
                    lineHeight: 0.8
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 30
                    anchors.verticalCenterOffset: -10
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
                    text: modelData.games.count + " 游戏"
                    font.pixelSize: 18
                    font.letterSpacing: -0.3
//                    font.bold: true
                    color: itemTextColor
                    opacity: 0.7    
                    anchors.topMargin: 8
                    anchors.left: parent.left
                    anchors.leftMargin: 30
                    anchors.top: title.bottom
                    visible: true
                }    

                Text {
                    text: systemCompanies[modelData.shortName].toUpperCase()
                    font.family: systemSubitleFont.name
                    font.pixelSize: 14
                    font.letterSpacing: 0.5
//                    font.bold: true
                    color: itemTextColor
                    opacity: 0.7    
                    anchors.bottomMargin: -1
                    anchors.left: parent.left
                    anchors.leftMargin: 30
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
