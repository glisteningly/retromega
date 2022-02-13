import QtQuick 2.12
import QtGraphicalEffects 1.12

Item { 
    id: listContent

    property string context : "default"

    property string gameListViewMode : currentGameListViewMode
    
    property var listIdentifier: {
        return gameView
    }

//    property var currentGameView: {
//        return currentGameListViewMode === 'list' ? gameView : gameView
//    }

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
    property string viewType : 'list'
    property alias currentIndex : gameView.currentIndex
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

        if (event.key === 1048586 || event.key === 32) {
            toggleGameListViewMode()
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

//    Rectangle {
//        id: mainListContent
//        color: theme.background_dark
////        color: "transparent"
//        width: parent.width
//        height: parent.height
//        anchors.top: parent.top
//        anchors.bottom: parent.bottom
    
//        /**
//        * -----
//        * Games List
//        * ----
//        */
//        Rectangle {
//            id: games
//            visible: true
//            color: "transparent"
//            width: parent.width / 2
//            height: parent.height
//            anchors.left: parent.left
//            anchors.top: parent.top
//            anchors.bottom: parent.bottom
//            clip: true
             
//            ListView {
//              id: gameView
//              model: items
//              delegate: gameViewDelegate
//              height: parent.width
//              width: parent.height
//              anchors.left: parent.left
//              anchors.bottom: parent.bottom
//              anchors.margins: 32
//              anchors.bottomMargin: 6
//              anchors.topMargin: 2
//              anchors.top: parent.top
//              currentIndex: defaultIndex
//              snapMode: ListView.SnapOneItem
//              highlightRangeMode: ListView.ApplyRange
//              highlightMoveDuration: 0
//              preferredHighlightBegin: height * 0.5 - 15
//              preferredHighlightEnd: height * 0.5 + 15

//              focus: listContent.activeFocus
//                Keys.onUpPressed: {
//                    if (focusSeeAll) {
//                        focusSeeAll = false
//                    } else if (gameView.currentIndex == 0) {
//                        event.accepted = false
//                    } else {
//                        decrementCurrentIndex();
//                        event.accepted = true
//                    }
//                }

//                Keys.onDownPressed:     {
//                    if (gameView.currentIndex == items.count - 1 && showSeeAll) {
//                        focusSeeAll = true
//                    } else {
//                        incrementCurrentIndex();
//                        event.accepted = true
//                    }
//                }

//                Keys.onRightPressed: {
//                    event.accepted = true
//                    gameView.currentIndex = Math.min(gameView.currentIndex + 10, items.count - 1)
//                    return
//            //        showIndex = false
//                }

//                Keys.onLeftPressed: {
//                    event.accepted = true;
//                    gameView.currentIndex = Math.max(gameView.currentIndex - 10, 0);
//                    return;
//            //        showIndex = true
//                }

//                onCurrentIndexChanged: {
//                    if (visible) {
//                        navSound.play()
//                    }
//                }

//              move: Transition {
//                 NumberAnimation { properties: "x,y,contentY"; duration: 100 }
//              }
//              moveDisplaced: Transition {
//                 NumberAnimation { properties: "x,y"; duration: 100 }
//              }
//            }

//            Component.onCompleted: {
//                gameView.positionViewAtIndex(defaultIndex, ListView.Center)
//                delay(50, function() {
//                    gameView.positionViewAtIndex(defaultIndex, ListView.Center)
//                    if (currentHomeIndex <= 1 && !collectionListIndex) {
//                        currentIndex = -1
//                    }
//                })
////                currentIndex = defaultIndex
//            }
            
//            Component {
//                id: gameViewDelegate

//                Item {
//                  id: gameViewDelegateContainer
//                  width: games.width - 12 - 12 - 12
//                  height: rowHeight(index)
                  
//                  Keys.onPressed: {
//                        //Launch game
//                        if (api.keys.isCancel(event)) {
//                            if (showSeeAll) {
//                                focusSeeAll = false
//                            }

//                            if (currentHomeIndex <= 1) {
//                             event.accepted = true;
//                             gameList.currentIndex = -1
//                             navigate('HomePage');
//                         }
//                        }
//                        if (api.keys.isAccept(event)) {
//                            event.accepted = true;

//                            if (selectSeeAll) {
//                                focusSeeAll = false
//                                navSound.play()
//                                //gameView.currentIndex = 0
//                                onSeeAll()
//                            } else {
//                                startGame(modelData, index)
//                            }
//                            return;
//                        }

//                        // // Details
//                        // if (api.keys.isDetails(event) && !hideFavoriteIcon) {
//                        //     modelData.favorite = !modelData.favorite
//                        //     event.accepted = true
//                        //     navSound.play()
//                        //     return
//                        // }

//                        //Next page
//                        if (api.keys.isPageDown(event)) {
//                           event.accepted = true
//                           gameView.currentIndex = Math.min(gameView.currentIndex + 10, items.count - 1)
//                           return
//                        }
                        
//                        //Prev collection
//                        if (api.keys.isPageUp(event)) {
//                            event.accepted = true;
//                            gameView.currentIndex = Math.max(gameView.currentIndex - 10, 0);
//                            return;
//                        }

//                        event.accepted = false
//                  }

//                  ListRow {
//                    title: modelData ? modelData.title : emptyTitle
//                    //title: modelData.title
//                    selected: parent.ListView.isCurrentItem && gameView.activeFocus && !selectSeeAll && modelData ? true : false
//                    width: parent.width
//                    emptyStyle: modelData ? false : true
//                    height: 38
//                    rowColor: gamesColor
//                    favorite: modelData.favorite && !hideFavoriteIcon
//                  }

//                  Item {
//                      id: see_all
//                      width: parent.width
//                      height: 38
//                      visible: isLastRow(index) && showSeeAll
//                      anchors.top: parent.top
//                      anchors.topMargin: 48
//                      Rectangle {
//                          width: parent.width
//                          anchors.top: parent.top
//                          height: 1
//                          color: "white"
//                          opacity: 0.1
//                      }
//                      ListRow {
//                          title: "显示全部"
//                          selected: selectSeeAll
//                          width: parent.width
//                          anchors.bottom: parent.bottom
//                          height: 38
//                          rowColor: gamesColor
//                          favorite: false
//                      }
//                  }

//                }
//            }

//        }
          
//        Rectangle {
//            id: game_detail
//            visible: true
//            color: "transparent"
//            width: 320
//            height: parent.height
//            anchors.rightMargin: 0
//            anchors.right: parent.right
//            anchors.top: header.top
//            anchors.bottom: parent.bottom
//            z: 2001

//            states: [
//                State{
//                    name: "indexHidden"; when: !showIndex
//                    PropertyChanges { target: game_detail; anchors.rightMargin: 0}
//                },

//                State{
//                    name: "indexActive"; when: showIndex
//                    PropertyChanges { target: game_detail; anchors.rightMargin: -16}
//                }
//            ]

//            transitions:[
//                Transition {
//                    NumberAnimation { properties: "anchors.rightMargin"; easing.type: Easing.OutCubic; duration: 250  }
//                }
//            ]

//            BoxArt {
//                id: game_box_art
//                asset: selectedGame && gameView.currentIndex >= 0 && !focusSeeAll ? selectedGame.assets.boxFront : ""
//                context: currentCollection.shortName + listContent.context
//             }

//        }
//    }


    Rectangle {
        id: mainGridContent
        color: theme.background_dark
        width: parent.width
        height: parent.height
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        clip: true

        GridView {
                id: gameView
    //            visible: false
    //            enabled: false
                focus: listContent.activeFocus
                readonly property int maxRecalcs: 5
                property int currentRecalcs: 0
                property real cellHeightRatio: 1

                property real columnCount: {
//                    if (cellHeightRatio > 1.2) return 6;
                    if (cellHeightRatio < 0.8) return 4;
                    return 5;
                }

                model: parent.visible ? items : []
                anchors.fill: parent
                currentIndex: defaultIndex
                anchors.left: parent.left
                anchors.leftMargin: 12
                anchors.right: parent.right
                anchors.rightMargin: 12
                anchors.margins: 12
                cacheBuffer: 10

                highlightRangeMode: GridView.ApplyRange
                highlightMoveDuration: 0
                preferredHighlightBegin: height * 0.5 - vpx(120)
                preferredHighlightEnd: height * 0.5 + vpx(120)

                function cells_need_recalc() {
                    currentRecalcs = 0;
                    cellHeightRatio = 1;
                }

                function update_cell_height_ratio(img_w, img_h) {
                    if (currentHomeIndex === 0) {
                        // 限制图片的最大宽高比
                        cellHeightRatio = Math.min(Math.max(0.67, img_h / img_w), 1.67);
    //                    cellHeightRatio =  img_h / img_w
                    } else {
                        return 1.0
                    }
                }


                cellWidth: width / columnCount
                cellHeight: cellWidth * cellHeightRatio + 20;

                displayMarginBeginning: anchors.topMargin

                Component.onCompleted: {
    //                gameView.positionViewAtIndex(defaultIndex, GridView.Center)
    //                delay(50, function() {
    //                    gameView.positionViewAtIndex(defaultIndex, GridView.Center)
    //                    if (currentHomeIndex <= 1 && !collectionListIndex) {
    //                        currentIndex = -1
    //                    }
    //                })
    //                currentIndex = defaultIndex
                }

                onVisibleChanged: {
                    if (visible) {
                        positionViewAtIndex(currentGameIndex, GridView.Center)
                        delay(0, function() {
                            gameView.positionViewAtIndex(currentGameIndex, GridView.Center)
                        })
                    }
                }

                onCurrentIndexChanged: {
                    if (visible) {
                      navSound.play()
                    }
                }

                Keys.onPressed: {
                    if (event.isAutoRepeat)
                        return;

                    if (api.keys.isPageUp(event) || api.keys.isPageDown(event)) {
                        event.accepted = true;
                        var rows_to_skip = Math.max(1, Math.round(gameView.height / cellHeight));
                        var games_to_skip = rows_to_skip * columnCount;
                        if (api.keys.isPageUp(event))
                            currentIndex = Math.max(currentIndex - games_to_skip, 0);
                        else
                            currentIndex = Math.min(currentIndex + games_to_skip, items.count - 1);
                    }
                }

    //            highlight: Rectangle {
    //                color:  theme.primaryColor
    //                opacity: headerFocused ? 0.1 : 0.3
    //                width: grid.cellWidth
    //                height: grid.cellHeight
    //                scale: 1.1
    //                radius: vpx(12)
    //                z: 2
    //            }

                delegate: GameGridItem {
                    id: game_griditem_container
                    gameData: modelData
                    width: GridView.view.cellWidth
                    height: GridView.view.cellHeight
                    selected: GridView.isCurrentItem

                    onClicked: {
                        if (GridView.view.currentIndex === index) {
                            startGame(modelData, index)
                        } else {
                            GridView.view.currentIndex = index
                        }
                    }

                    Keys.onPressed: {
                        if (api.keys.isAccept(event) && !event.isAutoRepeat) {
                          startGame(modelData, index)
                        }

                        if (api.keys.isCancel(event)) {
                            if (currentHomeIndex <= 1) {
                                event.accepted = true;
                                gameList.currentIndex = -1
                                navigate('HomePage');
                            }
                        }
                        event.accepted = false
                    }

                    onImageLoaded: {
                        if (gameView.currentRecalcs < gameView.maxRecalcs) {
                            gameView.currentRecalcs++;
                            gameView.update_cell_height_ratio(imageWidth, imageHeight);
                        }
                    }
                }
            }
       }
}
