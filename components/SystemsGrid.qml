import QtQuick 2.12
import QtGraphicalEffects 1.12
//import QtQuick.Controls 2.15

GridView {
    id: systemsGridView

    property var footerTitle: {
        return (currentIndex + 1) + " / " + allSystems.count
    }
    property int columnCount: {
        return theme.gridColumnCount;
    }
    property real cellHeightRatio: 0.8

    model: allSystems
    currentIndex: currentSystemIndex
//    width: parent.width - 8
//    anchors.verticalCenter: parent.verticalCenter
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

    Component.onCompleted: {
        delay(50, function() {
            positionViewAtIndex(currentSystemIndex, GridView.Center)
        })
        systemsBackground.bgIndex = currentIndex
    }

    onVisibleChanged: {
        if (visible) {
            positionViewAtIndex(currentSystemIndex, GridView.Center)
            delay(0, function() {
                positionViewAtIndex(currentSystemIndex, GridView.Center)
            })
        }
    }

    onCurrentIndexChanged: {
        if (visible) {
          navSound.play()
          setCurSystemIndex(currentIndex)
        }
    }

    Keys.onPressed: {
        if (event.isAutoRepeat)
            return;

        if (api.keys.isPageUp(event) || api.keys.isPageDown(event)) {
            event.accepted = true;
//            navSound.play()
            var rows_to_skip = Math.max(1, Math.round(systemsGridView.height / cellHeight));
            var games_to_skip = rows_to_skip * columnCount;
            if (api.keys.isPageUp(event))
                currentIndex = Math.max(currentIndex - games_to_skip, 0);
            else
                currentIndex = Math.min(currentIndex + games_to_skip, model.count - 1);
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

    delegate: SystemsGridItem {
        id: system_griditem_container
        width: GridView.view.cellWidth
        height: GridView.view.cellHeight
        selected: GridView.isCurrentItem
        collection: modelData

        function enterGamePage() {
            //We update the collection we want to browse
            setCollectionListIndex(0)
            setSystemIndex(system_griditem_container.GridView.view.currentIndex)

            //We change Pages
            navigate('GamesPage');
        }

        onClicked: {
            if (GridView.view.currentIndex === index) {
                enterGamePage()
            } else {
                GridView.view.currentIndex = index
            }
        }

        Keys.onPressed: {
            if (api.keys.isAccept(event) && !event.isAutoRepeat) {
                enterGamePage()
            }
        }
    }
}
