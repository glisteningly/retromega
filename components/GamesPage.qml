import QtQuick 2.12
import QtGraphicalEffects 1.12

Item {
    id: gamesPage
    anchors.leftMargin: 200

    state: currentGameListViewMode
    
    property var showSort: false
    //property var showGameDetail : false

    //    property alias currentIndex: gameList.currentIndex
    //    property alias showIndex: gameList.showIndex
    property int currentIndex: 0
    function setCurrentIndex(index) {
        currentIndex = index
    }


    property var footerTitle: {
        //        return gameList.footerTitle
        //        return currentIndex
        if (gamesItems.count > 0) {
            return (currentIndex + 1) + " / " + gamesItems.count
        } else {
            return curDataText.global_no_games
        }
    }

    property var isSystemPage: {
        return currentHomeIndex === 0
    }

    property var headerTitle: {
        return (collectionShowAllItems) ? curDataText.global_all + " " + currentCollection.name : currentCollection.name
    }
    
    //    property bool showIndex: false
    property var collectionSortTitle: {
        var title = curDataText.global_title
        switch (collectionSortMode) {
        case "title":
            title = curDataText.sort_title
            break
        case "lastPlayed":
            title = curDataText.sort_last_played
            break
        case "rating":
            title = curDataText.sort_rating
            break
        case "favorites":
            title = curDataText.sort_favorites_only
            break
        case "release":
            title = curDataText.sort_release_year
            break
        case "playCount":
            title = curDataText.sort_play_count
            break
        case "playTime":
            title = curDataText.sort_play_time
            break
        default:
            title = curDataText.sort_by
            break
        }

        if (collectionFilterMode == "favorites" && !collectionShowAllItems) {
            return curDataText.global_favorite + ", " + title
        }  else {
            return title
        }
    }

    property var onShow: function() {
        //        gameList.currentIndex = collectionListIndex
    }

    property var isFavoritesList: {
        return (collectionFilterMode == "favorites" && !collectionShowAllItems)
    }

    function onSeeAllEvent() {
        setCollectionListIndex(0)
        setCollectionShowAllItems(true)
    }

    function goBack() {
        gameList.currentIndex = -1
        gameList.box_art.initialLoad = true
        navigate('HomePage')
    }

    Component.onCompleted: {
        onShow()
    }

    width: parent.width
    height: parent.height

    Keys.onPressed: {

        // Show / Hide Sort
        //        if (api.keys.isFilters(event)) {
        //            event.accepted = true;
        //            showSort = !showSort
        //            return;
        //        }

        // Back to Home
        if (api.keys.isCancel(event)) {
            event.accepted = true
            //if (showGameDetail) {
            //showGameDetail(null)
            //showGameDetail = false
            //listFocus.focus = true
            if (showSort) {
                showSort = false
                backSound.play()
            } else if (collectionShowAllItems) {
                gameList.currentIndex = -1
                gameList.box_art.initialLoad = true
                setCollectionShowAllItems(false)
                backSound.play()
            } else {
                goBack()
            }
            return
        }

        if (event.key === 1048586 || event.key === 32) {
            toggleGameListViewMode(currentIndex)
        }

        event.accepted = false
    }


    property var emptyModel: {
        return {  title: "No Favorites",
            favorite: true
        }
    }

    ListModel {
        id: emptyListModel
        ListElement {
            isEmptyRow: true
            emptyTitle: "No Favorites"
        }
    }

    property var gamesItems: {
        if (collectionShowAllItems) {
            return currentCollectionGamesSorted
        } else if (collectionFilterMode == "favorites" && currentCollectionGamesSortedFiltered.count === 0) {
            return emptyListModel
        } else {
            return currentCollectionGamesSortedFiltered
        }
    }


    Item {
        id: gamesPageContent
        anchors.fill: parent
        width: parent.width
        height: parent.height

        Rectangle {
            id: background
            color: theme.background
            anchors.fill: parent
        }
        
        /**
        * Footer
        */
        Rectangle {
            id: footer
            color: "transparent"
            width: parent.width
            height: 40
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.rightMargin: 0
            anchors.bottom: parent.bottom
            clip:true

            Rectangle {
                anchors.leftMargin: 22
                anchors.rightMargin: 22
                anchors.left: parent.left
                anchors.right: parent.right
                color: "#e3e3e3"
                anchors.top: parent.top
                height: 1
            }

            Text {
                text: footerTitle
                font.family: systemSubitleFont.name
                anchors.right: parent.right
                anchors.rightMargin: 32
                color: "#9B9B9B"//theme.title
                font.pixelSize: 18
                font.letterSpacing: 0.3
                //                font.bold: true
                anchors.verticalCenter: parent.verticalCenter
                elide: Text.ElideRight
                height: 20
            }

            ButtonLegend {
                id: button_legend_start
                title: curDataText.games_play
                key: "A"
                width: 55
                anchors.left: parent.left
                anchors.leftMargin: 32
                anchors.verticalCenter: parent.verticalCenter
            }

            ButtonLegend {
                id: button_legend_back
                title: curDataText.global_back
                key: "B"
                width: 55
                anchors.left: button_legend_start.right
                anchors.leftMargin: 32
                anchors.verticalCenter: parent.verticalCenter
            }

            ButtonLegend {
                id: button_legend_details
                title: curDataText.games_info
                key: "X"
                width: 55
                visible: true//collectionFilterMode == "all" || collectionShowAllItems
                anchors.left: button_legend_back.right
                anchors.leftMargin: 32
                anchors.verticalCenter: parent.verticalCenter
            }

            ButtonLegendSquare {
                //              visible: currentHomeIndex == 0
                id: button_legend_sel
                title: curDataText.global_view
                key: "SEL"
                width: 55
                anchors.left: button_legend_details.right
                anchors.leftMargin: 32
                anchors.verticalCenter: parent.verticalCenter
            }

            // ButtonLegend {
            //     id: button_legend_grid
            //     title: "Grid"
            //     key: "X"
            //     width: 55
            //     anchors.left: collectionFilterMode == "all" ? button_legend_details.right : button_legend_back.right
            //     anchors.leftMargin: 24
            //     anchors.verticalCenter: parent.verticalCenter
            // }

        }


        /**
        * Header
        */
        Rectangle {
            id: header
            color: "#333"
            width: parent.width
            height: vpx(50)
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.rightMargin: 0
            anchors.top: parent.top
            clip:true

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                color: "#222"
                anchors.bottom: parent.bottom
                height: 1
            }

            Rectangle {
                id: backBtn
                width: parent.height
                anchors {
                    top: parent.top
                    left: parent.left
                    bottom: parent.bottom
                }
                color: "#33000000"

                Image {
                    width: vpx(24)
                    height: vpx(24)
                    source: "../assets/icons/ic-back.svg"
                    anchors {
                        centerIn: parent
                    }
                }

                TapHandler {
                    gesturePolicy: TapHandler.ReleaseWithinBounds
                    onTapped: navigate('HomePage')
                }
            }

            Text{
                text: headerTitle
                anchors {
                    left: backBtn.right
                    leftMargin: vpx(16)
                    verticalCenter: parent.verticalCenter
                    verticalCenterOffset: isSystemPage ? 3 : 0
                }
                //                color: systemColor//theme.title
                color: "#EEE"
                font.pixelSize: isSystemPage ? vpx(30) : vpx(28)
                font.letterSpacing: 0.3
                font.family: isSystemPage ? systemTitleFont.name : collectionTitleFont.name

                width:300
                elide: Text.ElideRight
            }


            HeaderInfoBar {
                height: parent.height
                anchors {
                    right: parent.right
                }
            }
        }

        /**
         * Main List
         */
        FocusScope {
            id: listFocus
            focus: currentPage === "GamesPage" && !showSort && !isShowingGameDetail ? true : false ;
            width: parent.width
            height: parent.height
            anchors.top: header.bottom
            //            anchors.bottom: footer.top
            anchors.bottom: parent.bottom


            Loader {
                id: gameListContainer
                sourceComponent: currentGameListViewMode === 'list' ? gameListView : gameGridView
                anchors.fill: parent
                focus: true
            }
            
            Component {
                id: gameGridView
                GameGridView {
                    id: gameList
                    defaultIndex: collectionListIndex
                    width: parent.width
                    height: parent.height
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    gamesColor: systemColor
                    items:  gamesItems
                    indexItems: gamesPage.isFavoritesList ? currentFavorites : currentCollection.games
                    context: collectionShowAllItems ? "all" : "default"
                    showSeeAll: gamesPage.isFavoritesList
                    hideFavoriteIcon: gamesPage.isFavoritesList
                    onSeeAll: onSeeAllEvent
                    sortMode: collectionSortMode
                    sortDirection: collectionSortDirection
                    focus: true  && !isShowingGameDetail
                }
            }

            Component {
                id: gameListView
                GameListView {
                    id: gameList
                    defaultIndex: collectionListIndex
                    width: parent.width
                    height: parent.height
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    gamesColor: systemColor
                    items:  gamesItems
                    indexItems: gamesPage.isFavoritesList ? currentFavorites : currentCollection.games
                    context: collectionShowAllItems ? "all" : "default"
                    showSeeAll: gamesPage.isFavoritesList
                    hideFavoriteIcon: gamesPage.isFavoritesList
                    onSeeAll: onSeeAllEvent
                    sortMode: collectionSortMode
                    sortDirection: collectionSortDirection
                    focus: true  && !isShowingGameDetail
                }
            }
        }

        DropShadow {
            anchors.fill: header
            source: header
            verticalOffset: vpx(5)
            horizontalOffset: 0
            color: "#88000000"
            radius: 10
            samples: 20
        }
    }

    SortModal {
        active: showSort
        sortColor: systemColor
    }
}
