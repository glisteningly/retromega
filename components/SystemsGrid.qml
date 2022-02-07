import QtQuick 2.12
import QtGraphicalEffects 1.12
//import QtQuick.Controls 2.15

GridView {
    id: systemsGridView

    property var footerTitle: {
        return (currentIndex + 1) + " / " + allSystems.count
    }
    property bool headerFocused: false
    property int columnCount: {
        return theme.gridColumnCount;
    }
    readonly property int maxRecalcs: 5
    property int currentRecalcs: 0
    property real cellHeightRatio: 0.8


    model: allSystems
    currentIndex: currentSystemIndex
    width: parent.width
    anchors.verticalCenter: parent.verticalCenter
    anchors.left: parent.left
    anchors.leftMargin: 12
    anchors.right: parent.right
    anchors.rightMargin: 12
    anchors.top: parent.top
    anchors.topMargin: 6
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 12
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

    Keys.onPressed: {
        if (event.isAutoRepeat)
            return;

        if (api.keys.isPageUp(event) || api.keys.isPageDown(event)) {
            event.accepted = true;
            navSound.play()
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
        id: home_griditem_container
        width: GridView.view.cellWidth
        height: GridView.view.cellHeight
        selected: GridView.isCurrentItem

        collection: modelData

        onClicked: GridView.view.currentIndex = index

        Keys.onPressed: {
            if (api.keys.isAccept(event) && !event.isAutoRepeat) {
//                //We update the collection we want to browse
                setCollectionListIndex(0)
                setSystemIndex(home_griditem_container.GridView.view.currentIndex)

                //We change Pages
                navigate('GamesPage');

                return;
            }
        }
    }
}
