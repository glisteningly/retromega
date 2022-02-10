import QtQuick 2.12
import QtGraphicalEffects 1.12

Item {
    id: homepage  
    width: parent.width
    height: parent.height

    property var currentView: {
        switch (currentHomeIndex) {
        case 0: 
//            return systemsListView
            return currentSystemViewMode === 'grid' ? systemsGridView : systemsListView
        case 1:
            return collectionListView
        case 2: 
            return favoriteView
        case 3:
            return recentsView
        default: 
            return ""
        }
    }

    property var currentContentView: {
        switch (currentHomeIndex) {
        case 0: 
//            return systemsListView
            return currentSystemViewMode === 'grid' ? systemsGridView : systemsListView
        case 1:
            return collectionListView
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
        if (currentSystemViewMode === 'grid' && currentHomeIndex <= 0) {
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
            navSound.play()
            return
        }  
        
        // Next
//        if (api.keys.isPageDown(event)) {
        if (api.keys.isNextPage(event)) {
            event.accepted = true;
            setHomeIndex(Math.min(currentHomeIndex + 1,3))
            navSound.play();
            return;
        }  

//        if (api.keys.isFilters(event) || event.key === 32) {
        if (event.key === 1048586 || event.key === 32) {
            if (currentHomeIndex == 0){
                toggleSystemViewMode()
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
        anchors.bottom: homepage.bottom
        visible: true
        z: (currentHomeIndex <= 1) ? 1 : 0
    }


    FocusScope {
        id: mainFocus
        focus: currentPage === "HomePage" && !isShowingGameDetail ? true : false ;

        anchors {
            left: parent.left
            right: parent.right
            top: header.bottom
            bottom: footer.top
        }

        Keys.onPressed: {                                            
            // Back to Home            
//            if (api.keys.isCancel(event)) {
//                if (currentContentView && currentContentView.showIndex) {
//                    currentContentView.showIndex = false
//                } else {
//                    header.focused_link.forceActiveFocus()
//                }
//                event.accepted = true;
//            } else {
//                event.accepted = false;
//            }
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
                SystemsListLarge {
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    //anchors.verticalCenter: parent.verticalCenter
                    height: parent.height
                    width: parent.width
                    visible: currentHomeIndex == 0 && currentSystemViewMode === 'list'
                    focus: currentHomeIndex == 0 && currentSystemViewMode === 'list'
                    enabled: currentHomeIndex == 0 && currentSystemViewMode === 'list'
                    headerFocused: header.anyFocused
                    id: systemsListView
                }

                SystemsGrid {
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    //anchors.verticalCenter: parent.verticalCenter
                    height: parent.height
                    width: parent.width
                    visible: currentHomeIndex == 0 && currentSystemViewMode === 'grid'
                    focus: currentHomeIndex == 0 && currentSystemViewMode === 'grid'
                    enabled: currentHomeIndex == 0 && currentSystemViewMode === 'grid'
                    headerFocused: header.anyFocused
                    id: systemsGridView
                }

                // Collections
                CollectionListLarge {
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    //anchors.verticalCenter: parent.verticalCenter
                    height: parent.height
                    width: parent.width
                    visible: currentHomeIndex == 1
                    focus: currentHomeIndex == 1
                    headerFocused: header.anyFocused
                    id: collectionListView
                }
                
                // Favourites
                Component {
                    id: favoriteView                    
                    GamesList {
                        id: favoritesContentView
                        width: parent.width
                        height: parent.height
                        items: allFavorites   
                        indexItems: allFavorites   
                        sortMode: "title"
                        focus: true && !isShowingGameDetail
                        hideFavoriteIcon: true
                    }
                }

                Loader  {
                    id: favoritesLoader
                    focus: currentHomeIndex == 2
                    active: opacity !== 0
                    opacity: focus ? 1 : 0
                    anchors.fill: parent
                    sourceComponent: favoriteView
                    asynchronous: false
                }                

                // Recents
                Component {
                    id: recentsView                    
                    GamesList {
                        id: recentsContentView
                        width: parent.width
                        height: parent.height
                        items: allRecentlyPlayed      
                        indexItems: allRecentlyPlayed
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
                    sourceComponent: recentsView
                    asynchronous: false
                }  
            } 
        }  
    }
}
