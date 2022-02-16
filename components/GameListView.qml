import QtQuick 2.12
import QtGraphicalEffects 1.12

Item { 
    id: listContent

    property alias currentIndex : gameView.currentIndex

    property string context : "default"

    property var footerTitle: {
        if (items.count > 0) {
            return (gameView.currentIndex + 1) + " / " + items.count
        } else if (items.count > 0) {
            return items.count
        } else {
            return "No Games"
        }
    }

    property var gamesColor : theme.primaryColor
    property var selectedGame: {
        return gameView.currentIndex >= 0 ? items.get(gameView.currentIndex) : items.get(0)
    }

//    property alias box_art : game_box_art
    property bool hideFavoriteIcon : false
    property int defaultIndex: 0
    property var items : []
    property var indexItems : []
//    property var showIndex : false
    property bool focusSeeAll : false
//    property var maintainFocusTop : false

    // Sort mode that the items have applied to them.
    // Is used to determine how to show the quick index.
    // Doesn't actually apply the sort to the collection.
    property string sortMode: "title"
    property int sortDirection: 0

    property var selectSeeAll : {
        if (showSeeAll) {
            if (focusSeeAll && !showIndex) {
                return true
            } else {
                if (items.count === 1 && !items.get(0).modelData) {
                    return true
                } else {
                    return false
                }
            }
        } else {
            return false
        }
    }

    property bool showSeeAll : false
    property var onSeeAll : ({})
    property var onIndexChanged : function(title, index) {
        
    }

//    onShowIndexChanged: {
//        if (showIndex) {
//            maintainFocusTop = true
//        } else {
//            maintainFocusTop = false
//            listContent.focus = true
//        }
//    }

//                Keys.onRightPressed: {
//                    event.accepted = true
//                    gameView.currentIndex = Math.min(gameView.currentIndex + 1, items.count - 1)
//                    return
//                }

//                Keys.onLeftPressed: {
//                    event.accepted = true;
//                    gameView.currentIndex = Math.max(gameView.currentIndex - 1, 0);
//                    return;
//                }

    Keys.onPressed: {
        // Show / Hide Index
        // Details
        if (api.keys.isDetails(event)) {
            event.accepted = true
            showGameDetail(selectedGame, gameView.currentIndex)
            return
        }
    }
    
    function isLastRow(currentIndex) {
        if (currentIndex === items.count - 1) {
            return true
        } else {
            return false
        }
    }

    function rowHeight(index) {
        if (isLastRow(index) && showSeeAll) {
            return 36 + 36
        } else {
            return 36
        }
    }

    function updatedIndex() {
        onIndexChanged(gameView.currentIndex, items.count)
    }

    function cells_need_recalc() {
        gameView.currentRecalcs = 0;
        gameView.cellHeightRatio = 1;
    }

    Rectangle {
        id: mainListContent
        color: theme.background_dark
//        color: "transparent"
        width: parent.width
        height: parent.height
        anchors.top: parent.top
        anchors.bottom: parent.bottom
    
        /**
        * -----
        * Games List
        * ----
        */
        Rectangle {
            id: games
            visible: true
            color: "transparent"
            width: parent.width / 2
            height: parent.height
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            clip: true
             
            ListView {
              id: gameView
              model: items
              delegate: gameViewDelegate
              height: parent.width
              width: parent.height
              anchors.left: parent.left
              anchors.bottom: parent.bottom
              anchors.margins: 32
              anchors.bottomMargin: 6
              anchors.topMargin: 2
              anchors.top: parent.top
              currentIndex: defaultIndex
              snapMode: ListView.SnapOneItem
              highlightRangeMode: ListView.ApplyRange
              highlightMoveDuration: 0
              preferredHighlightBegin: height * 0.5 - 15
              preferredHighlightEnd: height * 0.5 + 15

              focus: listContent.activeFocus
                Keys.onUpPressed: {
                    if (focusSeeAll) {
                        focusSeeAll = false
                    } else if (gameView.currentIndex == 0) {
                        event.accepted = false
                    } else {
                        decrementCurrentIndex();
                        event.accepted = true
                    }
                }

                Keys.onDownPressed:     {
                    if (gameView.currentIndex == items.count - 1 && showSeeAll) {
                        focusSeeAll = true
                    } else {
                        incrementCurrentIndex();
                        event.accepted = true
                    }
                }

                Keys.onRightPressed: {
                    event.accepted = true
                    gameView.currentIndex = Math.min(gameView.currentIndex + 10, items.count - 1)
                    return
            //        showIndex = false
                }

                Keys.onLeftPressed: {
                    event.accepted = true;
                    gameView.currentIndex = Math.max(gameView.currentIndex - 10, 0);
                    return;
            //        showIndex = true
                }

                onCurrentIndexChanged: {
                    if (visible) {
                        if (currentIndex >= 0) {
                            navSound.play()
                        }
                        setCurrentIndex(currentIndex)
                    }
                }

              move: Transition {
                 NumberAnimation { properties: "x,y,contentY"; duration: 100 }
              }
              moveDisplaced: Transition {
                 NumberAnimation { properties: "x,y"; duration: 100 }
              }
            }

            Component.onCompleted: {
                currentIndex = defaultIndex
            }

            onVisibleChanged: {
                if (visible) {
                    currentIndex = -1
                    gameView.positionViewAtIndex(defaultIndex, ListView.Center)
                    delay(50, function() {
                        gameView.positionViewAtIndex(defaultIndex, ListView.Center)
                        if (currentHomeIndex <= 1 && !collectionListIndex) {
                            currentIndex = 0
    //                        setCurrentIndex(currentIndex)
                        }
                    })
//                    console.log(defaultIndex)
                }
            }
            
            Component {
                id: gameViewDelegate

                Item {
                  id: gameViewDelegateContainer
                  width: games.width - 12 - 12 - 12
                  height: rowHeight(index)
                  
                  Keys.onPressed: {
                        //Launch game
                        if (api.keys.isCancel(event)) {
                            if (showSeeAll) {
                                focusSeeAll = false
                            }

                            if (currentHomeIndex <= 1) {
                             event.accepted = true;
                             gameList.currentIndex = -1
                             navigate('HomePage');
                         }
                        }
                        if (api.keys.isAccept(event)) {
                            event.accepted = true;

                            if (selectSeeAll) {
                                focusSeeAll = false
                                navSound.play()
                                //gameView.currentIndex = 0
                                onSeeAll()
                            } else {
                                startGame(modelData, index)
                            }
                            return;
                        }

                        // // Details
                        // if (api.keys.isDetails(event) && !hideFavoriteIcon) {
                        //     modelData.favorite = !modelData.favorite
                        //     event.accepted = true
                        //     navSound.play()
                        //     return
                        // }

                        //Next page
                        if (api.keys.isPageDown(event)) {
                           event.accepted = true
                           gameView.currentIndex = Math.min(gameView.currentIndex + 10, items.count - 1)
                           return
                        }
                        
                        //Prev collection
                        if (api.keys.isPageUp(event)) {
                            event.accepted = true;
                            gameView.currentIndex = Math.max(gameView.currentIndex - 10, 0);
                            return;
                        }

                        event.accepted = false
                  }

                  ListRow {
                    title: modelData ? modelData.title : emptyTitle
                    //title: modelData.title
                    selected: parent.ListView.isCurrentItem && gameView.activeFocus && !selectSeeAll && modelData ? true : false
                    width: parent.width
                    emptyStyle: modelData ? false : true
                    height: 38
                    rowColor: gamesColor
                    favorite: modelData.favorite && !hideFavoriteIcon
                  }

                  Item {
                      id: see_all
                      width: parent.width
                      height: 38
                      visible: isLastRow(index) && showSeeAll
                      anchors.top: parent.top
                      anchors.topMargin: 48
                      Rectangle {
                          width: parent.width
                          anchors.top: parent.top
                          height: 1
                          color: "white"
                          opacity: 0.1
                      }
                      ListRow {
                          title: "显示全部"
                          selected: selectSeeAll
                          width: parent.width
                          anchors.bottom: parent.bottom
                          height: 38
                          rowColor: gamesColor
                          favorite: false
                      }
                  }

                }
            }

        }
          
        Rectangle {
            id: game_detail
            visible: true
            color: "transparent"
            width: 320
            height: parent.height
            anchors.rightMargin: 0
            anchors.right: parent.right
            anchors.top: header.top
            anchors.bottom: parent.bottom
            z: 2001

            BoxArt {
                id: game_box_art
                asset: selectedGame && gameView.currentIndex >= 0 && !focusSeeAll ? selectedGame.assets.boxFront : ""
                context: currentCollection.shortName + listContent.context
             }

        }
    }
}
