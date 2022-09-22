import QtQuick 2.12
import QtGraphicalEffects 1.12
import "qrc:/qmlutils" as PegasusUtils

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
            return curDataText.global_no_games
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
    property var listRowHeight: vpx(50)

    property var selectSeeAll : {
        if (showSeeAll) {
            if (focusSeeAll) {
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

    Keys.onPressed: {
        // Show / Hide Index
        // Details
        if (api.keys.isDetails(event)) {
            event.accepted = true
            showGameDetail(selectedGame, gameView.currentIndex)
            return
        }
    }

    function updatedIndex() {
        onIndexChanged(gameView.currentIndex, items.count)
    }

    function cells_need_recalc() {
        gameView.currentRecalcs = 0;
        gameView.cellHeightRatio = 1;
    }

    onFocusChanged: {
        if (focus) {
            gameView.focus = true
        }
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
            anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
                margins: vpx(12)
            }
            clip: true

            Rectangle {
                id: listProgressBar
                width: vpx(8)
                height: vpx(100)
                anchors {
                    right: parent.right
                    top: parent.top
                    bottom: parent.bottom
                }
                color: "#22000000"

                Rectangle {
                    height: ((gameView.height / listRowHeight) / items.count) * gameView.height
                    width: parent.width
                    anchors {
                        left: parent.left
                        top: parent.top
                        topMargin: (gameView.height - height) * (gameView.currentIndex / (items.count - 1))
                    }
                    color: "#333"
                }
            }

            ListView {
                id: gameView
                model: parent.visible ? items : []
                delegate: gameViewDelegate
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                    rightMargin: vpx(12)
                    bottom: parent.bottom
                }
                currentIndex: defaultIndex
                //              snapMode: ListView.SnapToItem
                highlightRangeMode: ListView.ApplyRange
                highlightMoveDuration: 0
                preferredHighlightBegin: height * 0.5 - 15
                preferredHighlightEnd: height * 0.5 + 15
                clip: false
                keyNavigationEnabled: true
//                focus: listContent.activeFocus

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
                //                currentIndex = defaultIndex
                delay(50, function() {
                    if (gameView && visible) {
//                        gameView.focus = true
                        gameView.positionViewAtIndex(currentIndex, ListView.Center)
                        if (currentHomeIndex <= 1 && collectionListIndex) {
                            currentIndex = defaultIndex
                            //                        setCurrentIndex(currentIndex)
                        }
                    }
                })

            }

            onVisibleChanged: {
                if (gameView && visible) {
                    currentIndex = -1
                    gameView.positionViewAtIndex(defaultIndex, ListView.Center)
                    delay(50, function() {
                        if (gameView && visible) {
                            gameView.positionViewAtIndex(defaultIndex, ListView.Center)
                            if (currentHomeIndex <= 1 && !collectionListIndex) {
                                currentIndex = 0
                                //                        setCurrentIndex(currentIndex)
                            }
                        }
                    })
                    //                    console.log(defaultIndex)
                }
            }
            
            Component {
                id: gameViewDelegate

                Item {
                    id: gameViewDelegateContainer
                    width: parent? parent.width : 0
                    height: listRowHeight

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

                    GameListItem {
                        title: modelData ? modelData.title : emptyTitle
                        model: modelData ? modelData : null
                        selected: parent.ListView.isCurrentItem && gameView.activeFocus && !selectSeeAll && modelData ? true : false
                        width: parent.width
                        emptyStyle: modelData ? false : true
                        height: listRowHeight
                        favorite: modelData.favorite && !hideFavoriteIcon

                        onClicked: {
                            if (gameView.currentIndex === index) {
                                startGame(modelData, index)
                            } else {
                                gameView.currentIndex = index
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            id: game_detail
            visible: true
            color: "#22000000"
            width: parent.width * 0.5 - vpx(32)
            height: parent.height
            anchors {
                margins: vpx(12)
                right: parent.right
                top: parent.top
                bottom: parent.bottom
            }
            z: 2001

            Rectangle {
                color: "transparent"
                id: game_detail_image
                width: parent.width
                height: parent.height * 0.66 - vpx(32)
                anchors {
                    //                    margins: vpx(12)
                    left: parent.left
                    top: parent.top
                    topMargin: vpx(12)
                    //                    bottom: parent.bottom
                }

                Image {
                    width: parent.width
                    height: parent.height * 0.7
                    anchors {
                        bottom: parent.bottom
                    }
                    fillMode: Image.PreserveAspectCrop
                    z: 0
                    source: "../assets/images/bg_system_line.png"
                }

                BoxArt {
                    id: game_box_art
                    asset: selectedGame && gameView.currentIndex >= 0 ? selectedGame.assets.boxFront : ""
                    context: currentCollection.shortName + listContent.context
                }

                TapHandler {
                    gesturePolicy: TapHandler.ReleaseWithinBounds
                    onTapped: showGameDetail(selectedGame, gameView.currentIndex)
                }
            }

            //Description
            Rectangle {
                width: parent.width
                //                    height: gameDetailText.height - 40
                color: "#11FFFFFF"
                anchors {
                    top: game_detail_image.bottom
                    //                    topMargin: vpx(16)
                    //                    margins: vpx(8)
                    topMargin: vpx(12)
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                    bottomMargin: vpx(50)
                }

                Text {
                    anchors {
                        fill: parent
                        leftMargin: vpx(12)
                        rightMargin: vpx(12)
                        topMargin: vpx(10)
                        bottomMargin: vpx(10)
                    }
                    id: txt_game_description
                    width: parent.width
                    text: selectedGame.description || ""
                    font {
                        family: collectionTitleFont.name
                        pixelSize: vpx(21)
                    }
                    wrapMode: Text.WordWrap
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignJustify
                    color: "#999"
                }

                //                PegasusUtils.AutoScroll {
                //                    anchors.fill: parent
                //                    Text {
                //                        id: txt_game_description
                //                        width: parent.width
                //                        text: selectedGame.description
                //                        font {
                //                            weight: Font.Light
                //                            pixelSize: vpx(20)
                //                            letterSpacing: 0.4
                //                        }
                //                        wrapMode: Text.WordWrap
                //                        elide: Text.ElideRight
                //                        horizontalAlignment: Text.AlignJustify
                //                        color: "#999"
                //                    }
                //                }
            }
        }
    }
}
