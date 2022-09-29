import QtQuick 2.12
import QtGraphicalEffects 1.12

Item {
    id: listContent

    property alias currentIndex: gameView.currentIndex

    property string context: "default"

    property var footerTitle: {
        if (items.count > 0) {
            return (gameView.currentIndex + 1) + " / " + items.count
        } else if (items.count > 0) {
            return items.count
        } else {
            return curDataText.global_no_games
        }
    }

    property var gamesColor: theme.primaryColor
    property var selectedGame: {
        return gameView.currentIndex >= 0 ? items.get(gameView.currentIndex) : items.get(0)
    }

    //    property alias box_art : game_box_art
    property bool hideFavoriteIcon: false
    property int defaultIndex: 0
    property var items: []
    property var indexItems: []
    //    property var showIndex : false
    property bool focusSeeAll: false
    //    property var maintainFocusTop : false

    // Sort mode that the items have applied to them.
    // Is used to determine how to show the quick index.
    // Doesn't actually apply the sort to the collection.
    property string sortMode: "title"
    property int sortDirection: 0

    property var selectSeeAll: {
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

    property bool showSeeAll: false
    property var onSeeAll: ({})
    property var onIndexChanged: function (title, index) {}

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

    function updatedIndex() {
        onIndexChanged(gameView.currentIndex, items.count)
    }

    function cells_need_recalc() {
        gameView.currentRecalcs = 0
        gameView.cellHeightRatio = 1
    }

    onFocusChanged: {
        if (focus) {
            gameView.focus = true
        }
    }

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
//            focus: listContent.activeFocus
            readonly property int maxRecalcs: 5
            property int currentRecalcs: 0
            property real cellHeightRatio: 1.0

            property real columnCount: {
                return cellHeightRatio <= 0.8 ? gamelistColumns - 1 : gamelistColumns
            }

            model: parent.visible ? items : []
            currentIndex: defaultIndex
            anchors {
                fill: parent
                margins: vpx(12)
                topMargin: vpx(16)
                bottomMargin: vpx(16)
            }
            cacheBuffer: 30

            highlightRangeMode: GridView.ApplyRange
            highlightMoveDuration: 200
            preferredHighlightBegin: height * 0.5 - vpx(120)
            preferredHighlightEnd: height * 0.5 + vpx(120)

            function cells_need_recalc() {
                currentRecalcs = 0
                cellHeightRatio = 1
            }

            function update_cell_height_ratio(img_w, img_h) {
                if (currentHomeIndex === 0) {
                    // 限制图片的最大宽高比
                    cellHeightRatio = Math.min(Math.max(0.6 ,img_h / img_w), 1.8)
                } else {
                    return 1.0
                }
            }

            cellWidth: width / columnCount
            cellHeight: cellWidth * cellHeightRatio

            displayMarginBeginning: anchors.topMargin

            Component.onCompleted: {
                positionViewAtIndex(defaultIndex, GridView.Center)
                delay(200, function() {
                    if (gameView && visible) {
//                    gameView.focus = true
                    positionViewAtIndex(defaultIndex, GridView.Center)
//                    if (currentHomeIndex <= 1 && !collectionListIndex) {
//                        currentIndex = -1
//                    }
                    }
                })
//                currentIndex = defaultIndex
            }

            onVisibleChanged: {
                if (gameView && visible) {
                    cells_need_recalc()
                    currentIndex = 0
                    positionViewAtIndex(defaultIndex, GridView.Center)
                    delay(0, function () {
                        positionViewAtIndex(defaultIndex, GridView.Center)
                    })
                }
            }

            onCurrentIndexChanged: {
                if (visible) {
                    navSound.play()
                    setCurrentIndex(currentIndex)
                }
            }

            Keys.onPressed: {
//                if (event.isAutoRepeat)
//                    return

                if (api.keys.isPageUp(event) || api.keys.isPageDown(event)) {
                    event.accepted = true
                    var rows_to_skip = Math.max(1, Math.round(gameView.height / cellHeight))
                    var games_to_skip = rows_to_skip * columnCount

                    if (api.keys.isPageUp(event))
                        currentIndex = Math.max(currentIndex - games_to_skip, 0)
                    else
                        currentIndex = Math.min(currentIndex + games_to_skip, items.count - 1)
                }

                // press L3 or V
                if (event.key === 1048585 || event.key === 66) {
                    setGamelistColumnsDec()
                }

                // press R3 or B
                if (event.key === 1048582 || event.key === 86) {
                    setGamelistColumnsInc()
                }
            }

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
                            event.accepted = true
                            gameList.currentIndex = -1
                            navigate('HomePage')
                        }
                    }
                    event.accepted = false
                }

                onImageLoaded: {
                    if (gameView.currentRecalcs < gameView.maxRecalcs) {
                        gameView.currentRecalcs++
                        gameView.update_cell_height_ratio(imageWidth,imageHeight)
                    }
                }
            }
        }
    }
}
