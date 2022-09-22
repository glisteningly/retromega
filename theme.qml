import QtQuick 2.15
import QtGraphicalEffects 1.12
import QtMultimedia 5.9
import SortFilterProxyModel 0.2

import 'components' as Components
import './const.js' as Const
import './systems.js' as SYSTEM
import'./collections.js' as COLLECTION

FocusScope {
    id: root

    FontLoader { id: systemTitleFont; source: "assets/fonts/BebasNeue.otf" }
    FontLoader { id: systemSubitleFont; source: "assets/fonts/Acre.otf" }
    FontLoader { id: collectionTitleFont; source: "assets/fonts/AlibabaPuHuiTi-2-105-Heavy.otf" }

    property var boldTitleFont: { lang === 'cn'? collectionTitleFont.name : systemTitleFont.name }
    property var boldTitleLetterSpacing: { lang === 'cn'? 3 : 0 }

    property string lang: 'cn'
    property var dataText : Const.dataText
    property var curDataText: { dataText[lang] }

    property var theme : Const.theme
    property var systemInfoList: SYSTEM.systemInfoList
    property var collectionInfoList: COLLECTION.collectionInfoList


    Timer {
        id: timer
    }

    function delay(delayTime, cb) {
        timer.interval = delayTime;
        timer.repeat = false;
        timer.triggered.connect(cb);
        timer.start();
    }

    Component.onCompleted: {
        lang = api.memory.get('lang') || 'cn'
        currentHomeIndex = api.memory.get('homeIndex') || 0
        currentSystemIndex = api.memory.get('currentSystemIndex') || 0
        currentCollectionIndex = api.memory.get('currentCollectionIndex') || 0
        currentSystemViewMode = api.memory.get('currentSystemViewMode') || 'list'
        currentGameListViewMode = api.memory.get('currentGameListViewMode') || 'list'
        currentPage = api.memory.get('currentPage') || 'HomePage'
        collectionListIndex = api.memory.get('collectionListIndex') || 0
        collectionSortMode = api.memory.get('collectionSortMode') || "title"
        collectionSortDirection =  api.memory.get('collectionSortDirection') || 0
        collectionFilterMode =  api.memory.get('collectionFilterMode') || "all"
        collectionShowAllItems =  api.memory.get('collectionShowAllItems') || false
        collectionColumns = api.memory.get('collectionColumns') || 5
        systemColumns = api.memory.get('systemColumns') || 6
        gamelistColumns = api.memory.get('gamelistColumns') || 6
        startSound.play()
    }

    // Main homepage index
    property var currentHomeIndex: 0

    // Collection index
    property int currentSystemIndex : 0
    property var currentCollectionIndex : 0
    property var currentCollection: {
        if (currentHomeIndex === 0) {
            return allSystems.get(currentSystemIndex)
        } else if (currentHomeIndex === 1) {
            return allCollections.get(currentCollectionIndex)
        } else {
            return allSystems.get(currentSystemIndex)
        }
    }

    //    property string currentSystemViewMode : "grid"
    property string currentSystemViewMode : "list"
    function toggleSystemViewMode() {
        var _flag = (currentSystemViewMode === 'list')?'grid':'list'
        api.memory.set('currentSystemViewMode', _flag)
        currentSystemViewMode = _flag
    }

    property string currentGameListViewMode : "list"
    function toggleGameListViewMode() {
        var _flag = (currentGameListViewMode === 'list')?'grid':'list'
        api.memory.set('currentGameListViewMode', _flag)
        currentGameListViewMode = _flag
    }

    function setSystemIndex(index) {
        api.memory.set('currentSystemIndex', index)
        currentSystemIndex = index
    }

    function setCurSystemIndex(index) {
        currentSystemIndex = index
    }

    function setCollectionIndex(index) {
        api.memory.set('currentCollectionIndex', index)
        currentCollectionIndex = index
    }

    function setCurCollectionIndex(index) {
        currentCollectionIndex = index
    }

    // Collection list index
    property int collectionListIndex : 0
    function setCollectionListIndex(index) {
        api.memory.set('collectionListIndex', index)
        collectionListIndex = index
    }

    // Collection list index
    property bool collectionShowAllItems : false
    function setCollectionShowAllItems(show) {
        api.memory.set('collectionShowAllItems', show)
        collectionShowAllItems = show
    }

    // Games index
    property int currentGameIndex: 0
    property var currentGame: {
        return currentCollection.games? currentCollection.games.get(currentGameIndex) : null
    }


    // Systems grid columns
    property int systemColumns: theme.systemColumns
    function setSystemColumns(count) {
        systemColumns = count
        api.memory.set('systemColumns', count)
    }
    function setSystemColumnsDec() {
        if (systemColumns > 4) {
            setSystemColumns(systemColumns - 1)
        }
    }
    function setSystemColumnsInc() {
        if (systemColumns < 8) {
            setSystemColumns(systemColumns + 1)
        }
    }

    // Collections grid columns
    property int collectionColumns: theme.collectionColumns
    function setCollectionColumns(count) {
        collectionColumns = count
        api.memory.set('collectionColumns', count)
    }
    function setCollectionColumnsDec() {
        if (collectionColumns > 4) {
            setCollectionColumns(collectionColumns - 1)
        }
    }
    function setCollectionColumnsInc() {
        if (collectionColumns < 8) {
            setCollectionColumns(collectionColumns + 1)
        }
    }

    // gamelist grid columns
    property int gamelistColumns: theme.gamelistColumns
    function setGamelistColumns(count) {
        gamelistColumns = count
        api.memory.set('gamelistColumns', count)
    }
    function setGamelistColumnsDec() {
        if (gamelistColumns > 4) {
            setGamelistColumns(gamelistColumns - 1)
        }
    }
    function setGamelistColumnsInc() {
        if (gamelistColumns < 10) {
            setGamelistColumns(gamelistColumns + 1)
        }
    }

    // Collection sort mode
    // Collection list index
    property string collectionSortMode : "title"
    property int collectionSortDirection : 0
    property string collectionFilterMode : "all"

    function setCollectionSortMode(sortMode) {
        api.memory.set('collectionSortMode', sortMode)
        
        var direction = collectionSortDirection == 0 ? 1 : 0
        if (collectionSortMode !== sortMode || sortMode === "lastPlayed" || sortMode === "rating")  {

            switch (sortMode) {
            case "title":
                direction = 0
                break
            case "lastPlayed":
                direction = 1
                break
            case "rating":
                direction = 1
                break
            case "release":
                direction = 0
                break
            }
        }

        collectionSortDirection = direction
        collectionSortMode = sortMode
        api.memory.set('collectionSortDirection', direction)
    }

    function setCollectionFilterMode(filterMode) {
        api.memory.set('collectionFilterMode', filterMode)
        collectionFilterMode = filterMode
    }

    function setHomeIndex(index) {
        setCollectionListIndex(0)
        api.memory.set('homeIndex', index)
        currentHomeIndex = index
    }

    property var androidCollection: {
        return api.collections.get(0)
    }

    property string currentPage : 'HomePage';
    function setCurrentPage(page) {
        api.memory.set('currentPage', page)
        currentPage = page
    }

    property var currentGameDetail : null
    property int currentGameDetailIndex : 0
    property bool isShowingGameDetail : false
    function showGameDetail(game, index) {
        if (game) {
            forwardSound.play()
            currentGameDetail = game
            currentGameDetailIndex = index
            isShowingGameDetail = true
        } else {
            backSound.play()
            isShowingGameDetail = false
        }
    }

    // When the game is launching
    property bool launchingGame : false
    function startGame(game, index) {
        currentGameIndex = index
        setCollectionListIndex(index)
        launchSound.play()
        launchingGame = true
        game.launch()
        //        delay(400, function() {
        //            game.launch()
        //        })
    }
    
    property var systemColor: {
        if (currentPage === 'GamesPage') {
            return systemInfoList[currentCollection.shortName].color || theme.primaryColor
        } else {
            return theme.primaryColor
        }
    }



    property var layoutScreen : {
        "height": parent.height,
        "width": Math.min(parent.width,  parent.height * 2),
        "background": theme.background,
    }


    property var layoutHeader : {
        "width": layoutScreen.width,
        "height": vpx(50),
        "background": "transparent",
    }


    property var layoutFooter : {
        "width": layoutScreen.width,
        "height": 40,
        "background": "transparent",
        
    }

    property var layoutContainer : {
        "width": layoutScreen.width,
        "height": parent.height - layoutHeader.height - layoutHeader.height,
        "background": "transparent",
        
    }

    function navigate(page){
        setCurrentPage(page)
        if (page === 'HomePage') {
            backSound.play()
        } else {
            forwardSound.play()
        }
        if (page === 'GamesPage') {
            gamesPage.onShow()
        }
    }

    //Sounds
    SoundEffect {
        id: backSound
        source: "assets/sound/sound-back.wav"
        volume: 0.5
    }

    //Sounds
    SoundEffect {
        id: forwardSound
        source: "assets/sound/sound-forward.wav"
        volume: 0.5
    }

    SoundEffect {
        id: navSound
        source: "assets/sound/sound-click2.wav"
        volume: 1.0
    }

    SoundEffect {
        id: launchSound
        source: "assets/sound/sound-launch.wav"
        volume: 0.35
    }

    SoundEffect {
        id: startSound
        source: "assets/sound/sound-start.wav"
        volume: 0.35
    }
    
    property var lastPlayedMaximum: {
        if (allRecentlyPlayed.count >= theme.maxRecentlyPlayed - 1) {
            return theme.maxRecentlyPlayed - 1
        } else {
            return allRecentlyPlayed.count - 1
        }

//        return 30
    }

    SortFilterProxyModel {
        id: allSystems
        sourceModel: api.collections
        //        filters: ValueFilter { roleName: "name"; value: "Android"; inverted: true; }
        filters: ValueFilter { roleName: "summary"; value: "collection"; inverted: true; }
    }

    SortFilterProxyModel {
        id: allCollections
        sourceModel: api.collections
        //        filters: ValueFilter { roleName: "name"; value: "Android"; inverted: true; }
        filters: ValueFilter { roleName: "summary"; value: "collection"; }
    }

    SortFilterProxyModel {
        id: allFavorites
        sourceModel: api.allGames
        filters: ValueFilter { roleName: "favorite"; value: true; }
    }

    SortFilterProxyModel {
        id: allRecentlyPlayed
        sourceModel: api.allGames
        filters: ValueFilter { roleName: "lastPlayed"; value: ""; inverted: true; }
        sorters: RoleSorter { roleName: "lastPlayed"; sortOrder: Qt.DescendingOrder }
    }

    SortFilterProxyModel {
        id: filterLastPlayed
        sourceModel: allRecentlyPlayed
        filters: IndexFilter { maximumIndex: lastPlayedMaximum }
    }

    SortFilterProxyModel {
        id: currentFavorites
        sourceModel: currentCollection.games
        filters: ValueFilter { roleName: "favorite"; value: true; }
    }

    SortFilterProxyModel {
        id: currentCollectionGamesSortedFiltered
        sourceModel: currentCollection.games
        sorters: [
            RoleSorter { roleName: "favorite"; sortOrder: Qt.DescendingOrder },
            RoleSorter { roleName: "summary";}
//            RoleSorter { roleName: collectionSortMode; sortOrder: collectionSortDirection == 0 ? Qt.AscendingOrder : Qt.DescendingOrder }
        ]
        filters: ValueFilter { roleName: "favorite"; value: true; inverted: false; enabled: collectionFilterMode == "favorites" }
    }

    SortFilterProxyModel {
        id: currentCollectionGamesSorted
        sourceModel: currentCollection.games
//        sorters: RoleSorter { roleName: collectionSortMode; sortOrder: collectionSortDirection == 0 ? Qt.AscendingOrder : Qt.DescendingOrder }
        //        sorters: [
        //            RoleSorter { roleName: "favorite"; sortOrder: Qt.DescendingOrder },
        //            RoleSorter { roleName: collectionSortMode; sortOrder: collectionSortDirection == 0 ? Qt.AscendingOrder : Qt.DescendingOrder }
        //        ]

    }

    // Primary UI
    Rectangle {
        id: app
        color: '#000'
        width: layoutScreen.width
        height: layoutScreen.height
        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
        }

        // Home Page
        Components.HomePage {
            visible: currentPage === 'HomePage' ? 1 : 0 ;
        }

        // Games Page
        Components.GamesPage {
            id: gamesPage
            visible: currentPage === 'GamesPage' ? 1 : 0 ;
            opacity: 1.0
            transitions: Transition {
                NumberAnimation { properties: "opacity"; easing.type: Easing.InCubic; duration: 200  }
            }


        }

        // Game Detail
        Component {
            id: gameDetail
            Components.GameDetail {
                //visible: isShowingGameDetail
                id: gameDetailContentView
                width: layoutScreen.width
                height: layoutScreen.height
                anchors {
                    top: parent.top
                    horizontalCenter: parent.horizontalCenter
                }
                opacity: 1.0
                active: isShowingGameDetail
                game: currentGameDetail

                transitions: Transition {
                    NumberAnimation { properties: "opacity"; easing.type: Easing.OutCubic; duration: 1600  }
                }
            }
        }
    }

    //    FastBlur {
    //        visible: isShowingGameDetail
    //        id: blur
    //        anchors.fill: app
    //        source: app
    //        radius: 50
    //    }

    Loader  {
        id: gameDetailLoader
        focus: isShowingGameDetail
        active: isShowingGameDetail
        width: layoutScreen.width
        height: layoutScreen.height
        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
        }
        sourceComponent: gameDetail
        asynchronous: false
    }

    /**
        Loading Game Overlay
    */
    Rectangle {
        id: loading_overlay
        opacity: 0.0
        color: "#000000"
        anchors {
            fill: parent
        }
        states: [

            State{
                name: "default"; when: !launchingGame
                PropertyChanges { target: loading_overlay; opacity: 0.0}
            },

            State{
                name: "active"; when: launchingGame
                PropertyChanges { target: loading_overlay; opacity: 1.0}
            }

        ]

        transitions: Transition {
            NumberAnimation { properties: "opacity"; easing.type: Easing.OutInElastic; duration: 350  }
        }
        z: 2002
    }
}
