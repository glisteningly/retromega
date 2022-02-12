import QtQuick 2.12
import QtGraphicalEffects 1.12
//import QtQuick.Controls 2.15



    GridView {
//        id: gameListView
        id: gameListView2

        property int columnCount: {
//            return theme.gridColumnCount;
            return 6
        }
        readonly property int maxRecalcs: 5
        property int currentRecalcs: 0
        property real cellHeightRatio: 1


        model: items
        currentIndex: defaultIndex
        anchors.left: parent.left
        anchors.leftMargin: 12
        anchors.right: parent.right
        anchors.rightMargin: 12
        anchors.margins: 12
        cacheBuffer: 10
    //    delegate: systemsDelegate

        highlightRangeMode: GridView.ApplyRange
        highlightMoveDuration: 0
        preferredHighlightBegin: height * 0.5 - vpx(120)
        preferredHighlightEnd: height * 0.5 + vpx(120)

    //        function update_cell_height_ratio(img_w, img_h) {
    //            cellHeightRatio = Math.min(Math.max(cellHeightRatio, img_h / img_w), 1.5);
    //        }


        cellWidth: width / columnCount
        cellHeight: cellWidth * cellHeightRatio;

        displayMarginBeginning: anchors.topMargin
        focus: true

        Component.onCompleted: {
            gameListView.positionViewAtIndex(defaultIndex, GridView.Center)
            delay(50, function() {
                gameListView.positionViewAtIndex(defaultIndex, GridView.Center)
                if (currentHomeIndex <= 1 && !collectionListIndex) {
                    currentIndex = -1
                }
            })
//                currentIndex = defaultIndex
        }

        onVisibleChanged: {
            if (visible) {
                positionViewAtIndex(currentGameIndex, GridView.Center)
                delay(0, function() {
                    gameListView.positionViewAtIndex(currentGameIndex, GridView.Center)
                })
            }
        }

        onCurrentIndexChanged: {
            if (visible) {
              navSound.play()
//              setCurSystemIndex(currentIndex)
            }
        }

        Keys.onPressed: {
            if (event.isAutoRepeat)
                return;

            if (api.keys.isPageUp(event) || api.keys.isPageDown(event)) {
                event.accepted = true;
    //            navSound.play()
                var rows_to_skip = Math.max(1, Math.round(gameListView.height / cellHeight));
                var games_to_skip = rows_to_skip * columnCount;
                if (api.keys.isPageUp(event))
                    currentIndex = Math.max(currentIndex - games_to_skip, 0);
                else
                    currentIndex = Math.min(currentIndex + games_to_skip, items.count - 1);
            }
        }

    //    highlight: Rectangle {
    //        color:  theme.primaryColor
    //        opacity: headerFocused ? 0.1 : 0.3
    //        width: grid.cellWidth
    //        height: grid.cellHeight
    //        scale: 1.1
    //        radius: vpx(12)
    //        z: 2
    //    }

    //    highlightMoveDuration: 0

        delegate: GameGridItem {
            id: game_griditem_container
            width: GridView.view.cellWidth
            height: GridView.view.cellHeight
            selected: GridView.isCurrentItem

            gameData: modelData

            onClicked: GridView.view.currentIndex = index

//            Keys.onPressed: {
//                if (api.keys.isAccept(event) && !event.isAutoRepeat) {
//    //                //We update the collection we want to browse
//                    setCollectionListIndex(0)
//                    setSystemIndex(home_griditem_container.GridView.view.currentIndex)

//                    //We change Pages
//                    navigate('GamesPage');

//                    return;
//                }
//            }
        }
    }

