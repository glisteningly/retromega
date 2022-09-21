import QtQuick 2.12
import QtGraphicalEffects 1.12

Item {
    id: homepage  
    width: parent.width
    height: parent.height

    property alias systemloaderItem: systemLoader.item
    property alias collectionloaderItem: collectionLoader.item


    property var currentContentView: {
        switch (currentHomeIndex) {
        case 0: 
            return systemloaderItem
        case 1:
            return collectionloaderItem
        case 2: 
            return favoritesLoader.item
        case 3:
            return recentsLoader.item
        default: 
            return null
        }
    }

    property var footerTitle: {
        return currentContentView.footerTitle
    }

    property var backgroundColor: {
        if (currentSystemViewMode === 'grid' && currentHomeIndex <= 1) {
            return theme.background_grid
        } else {
            return currentHomeIndex <= 1 ? "#FEFEFE" : "transparent"
        }
    }

    Keys.onPressed: {
//        console.log('------')
//        console.log(event.key)

        // Prev
//        if (api.keys.isPageUp(event)) {
        if (api.keys.isPrevPage(event)) {
            event.accepted = true
            setHomeIndex(Math.max(currentHomeIndex - 1,0))
            return
        }  
        
        // Next
//        if (api.keys.isPageDown(event)) {
        if (api.keys.isNextPage(event)) {
            event.accepted = true;
            setHomeIndex(Math.min(currentHomeIndex + 1,3))
            return;
        }  

//        if (api.keys.isFilters(event) || event.key === 32) {
        if (event.key === 1048586 || event.key === 32) {
            if (currentHomeIndex <= 1){
                toggleSystemViewMode()
            } else {
                toggleGameListViewMode()
            }
        }
    }  

    Rectangle {
        id: rect
        anchors.fill: parent
        color: backgroundColor
    }

    HeaderHome {
        id: header
        z: 1
        light: (currentHomeIndex <= 1 && currentPage === "HomePage" && currentSystemViewMode === 'list')
    }

    Footer {
        id: footer
        title: footerTitle
        light: (currentHomeIndex == 0 && currentPage === "HomePage")
        anchors.bottom: parent.bottom
        visible: currentHomeIndex <= 1
        z: 1
    }

    GamesPageFooter {
        id: game_footer
        title: footerTitle
        light: (currentHomeIndex == 0 && currentPage === "HomePage")
        anchors.bottom: parent.bottom
        visible: (currentHomeIndex === 2 || currentHomeIndex === 3) && !isShowingGameDetail
        z: 1
    }


    FocusScope {
        id: mainFocus
        focus: currentPage === "HomePage" && !isShowingGameDetail ? true : false ;

        anchors {
            left: parent.left
            right: parent.right
            top: header.bottom
//            bottom: footer.top
            bottom: parent.bottom
        }

        Rectangle {
            id: main
            color: "transparent"
            anchors {
                fill: parent
            }
                        
            Rectangle {
                id: main_content
                color: "transparent"
                anchors {
                    fill: parent
                }

                // Systems

                Loader {
                    id: systemLoader
                    sourceComponent: currentSystemViewMode === 'list' ? systemList : systemGrid
                    visible: currentHomeIndex == 0
                    focus: currentHomeIndex == 0
                    anchors.fill: parent
                    asynchronous: false
                }

                Component {
                    id: systemList
                    SystemsListLarge {
                        id: systemsListView
                        anchors.fill: parent
                        focus: currentHomeIndex == 0
                    }
                }

                Component {
                    id: systemGrid
                    SystemsGrid {
                        id: systemsGridView
                        anchors.fill: parent
                        focus: currentHomeIndex == 0
                    }
                }

                Loader {
                    id: collectionLoader
                    sourceComponent: currentSystemViewMode === 'list' ? collectionList : collectionGrid
                    visible: currentHomeIndex === 1
                    focus: currentHomeIndex === 1
                    anchors.fill: parent
                    asynchronous: false
                }

                // Collections
                Component {
                    id: collectionList
                    CollectionsListLarge {
                        id: collectionsListView
                        anchors.fill: parent
                        focus: currentHomeIndex === 1
                    }
                }

                Component {
                    id: collectionGrid
                    CollectionsGrid {
                        id: collectionsGridView
                        anchors.fill: parent
                        focus: currentHomeIndex === 1
                    }
                }
                
                // Favourites
                Component {
                    id: favoriteListView
                    GameListView {
                        id: favoritesContentView
                        width: parent.width
                        height: parent.height
                        items: allFavorites   
                        indexItems: allFavorites   
                        sortMode: "title"
                        focus: true && !isShowingGameDetail
                        hideFavoriteIcon: true
                        defaultIndex: collectionListIndex
                    }
                }

                Component {
                    id: favoriteGridView
                    GameGridView {
                        id: favoritesContentView
                        width: parent.width
                        height: parent.height
                        items: allFavorites
                        indexItems: allFavorites
                        sortMode: "title"
                        focus: true && !isShowingGameDetail
                        hideFavoriteIcon: true
                        defaultIndex: collectionListIndex
                    }
                }

                Loader  {
                    id: favoritesLoader
                    focus: currentHomeIndex == 2
                    active: opacity !== 0
                    opacity: focus ? 1 : 0
                    anchors.fill: parent
                    sourceComponent: currentGameListViewMode === 'list' ? favoriteListView : favoriteGridView
                    asynchronous: false
                }                

                // Recents
                Component {
                    id: recentsListView
                    GameListView {
                        id: recentsContentView
                        width: parent.width
                        height: parent.height
                        items: filterLastPlayed
                        indexItems: filterLastPlayed
                        sortMode: "recent"
                        focus: true  && !isShowingGameDetail
                    }
                }

                Component {
                    id: recentsGridView
                    GameGridView {
                        id: recentsContentView
                        width: parent.width
                        height: parent.height
                        items: filterLastPlayed
                        indexItems: filterLastPlayed
                        sortMode: "recent"
                        focus: true  && !isShowingGameDetail
                    }
                }

                Loader  {
                    id: recentsLoader
                    focus: currentHomeIndex == 3
                    active: opacity !== 0
                    opacity: focus ? 1 : 0
                    anchors.fill: parent
                    sourceComponent: currentGameListViewMode === 'list' ? recentsListView : recentsGridView
                    asynchronous: false
                }  
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
