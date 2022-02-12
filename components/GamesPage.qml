import QtQuick 2.12
import QtGraphicalEffects 1.12

Item {
    id: gamesPage
    anchors.leftMargin: 200 
    
    property var showSort       : false
    //property var showGameDetail : false

    property alias currentIndex: gameList.currentIndex
//    property alias showIndex: gameList.showIndex

    property var footerTitle: {
        return gameList.footerTitle
    }

    property var headerTitle: {
        return (collectionShowAllItems) ? "All " + currentCollection.name : currentCollection.name
    }
    
//    property bool showIndex: false
    property var collectionSortTitle: {
        var title = "标题"
        switch (collectionSortMode) {
            case "title":
                title = "按标题"
                break
            case "lastPlayed":
                title = "按最后游玩"
                break
            case "rating":
                title = "按评分"
                break
            case "favorites":
                title = "按收藏"
                break           
            case "release":
                title = "按发售时间"
                break
            case "playCount":
                title = "按游戏次数"
                break                      
            case "playTime":
                title = "按游戏时间"
                break                       
            default:
                title = "按"
                break
        }

        if (collectionFilterMode == "favorites" && !collectionShowAllItems) {
            return "收藏, " + title
        }  else {
            return title
        }
    }

    property var onShow: function() {
        currentIndex = collectionListIndex
    }

    property var isFavoritesList: {
        return (collectionFilterMode == "favorites" && !collectionShowAllItems)
    } 

    function onSeeAllEvent() {        
        setCollectionListIndex(0)
        setCollectionShowAllItems(true)    
    }

    function cells_need_recalc() {
        gameList.cells_need_recalc()
    }

    Component.onCompleted: {
        onShow()
    }

    width: layoutScreen.width                
    height: layoutScreen.height                

    Keys.onPressed: {           

        // Show / Hide Sort
        if (api.keys.isFilters(event)) {
            event.accepted = true;
            showSort = !showSort
            return;
        }  

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
                gameList.currentIndex = -1
                gameList.box_art.initialLoad = true
                navigate('HomePage');
            }
            return
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
                title: "开始"
                key: "A"
                width: 55
                anchors.left: parent.left
                anchors.leftMargin: 32
                anchors.verticalCenter: parent.verticalCenter
            }

            ButtonLegend {
                id: button_legend_back
                title: "返回"
                key: "B"
                width: 55
                anchors.left: button_legend_start.right
                anchors.leftMargin: 24
                anchors.verticalCenter: parent.verticalCenter
            }

            ButtonLegend {
                id: button_legend_details
                title: "详细信息"
                key: "X"
                width: 75
                visible: true//collectionFilterMode == "all" || collectionShowAllItems
                anchors.left: button_legend_back.right
                anchors.leftMargin: 24
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
            color: "transparent"
            width: parent.width
            height: 40
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.rightMargin: 0
            anchors.top: parent.top
            clip:true

            Rectangle {
                anchors.leftMargin: 22
                anchors.rightMargin: 22
                anchors.left: parent.left
                anchors.right: parent.right
                color: "#e3e3e3"
                anchors.bottom: parent.bottom
                height: 1
            }

            Text{
                text: headerTitle
                anchors.left: parent.left
                anchors.leftMargin: 32
                color: systemColor//theme.title
                font.pixelSize: 18
//                font.letterSpacing: -0.3
                font.bold: true              
                anchors.verticalCenter: parent.verticalCenter
                width:300       
                elide: Text.ElideRight       
            }


            Text {
                id: header_time
                text: collectionSortTitle
                anchors.right: legend.left
                anchors.verticalCenter: parent.verticalCenter
//                anchors.top: parent.top
//                anchors.topMargin: 6
                anchors.rightMargin: 8
                color: "#9B9B9B"
                font.pixelSize: 18
                font.letterSpacing: 0.3
//                font.bold: true
            }   


            // Text {
            //     id: header_time
            //     text: Qt.formatTime(new Date(), "hh:mm")   
            //     anchors.right: parent.right
            //     anchors.top: parent.top
            //     anchors.topMargin: 16
            //     anchors.rightMargin: 32
            //     color: "#9B9B9B"
            //     font.pixelSize: 18
            //     font.letterSpacing: -0.3
            //     font.bold: true              
            // }   
            Rectangle{
                id: legend
                height:22
                width:22
                color:"#444"
                radius:10
                anchors.top: parent.top
                anchors.topMargin: 10
                //anchors.right: header_time.left  
                anchors.right: parent.right
                anchors.leftMargin: 0
                //anchors.rightMargin: 5
                anchors.rightMargin: 32
                Text{
                    text: "Y"
                    color:"white"         
                    font.pixelSize: 14
//                    font.letterSpacing: -0.3
                    font.bold: true              
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
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
            anchors.bottom: footer.top
            
            GamesList {
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

    SortModal {
        active: showSort
        sortColor: systemColor
    }
}
