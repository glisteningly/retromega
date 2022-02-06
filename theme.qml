import QtQuick 2.15
import QtGraphicalEffects 1.12
import QtMultimedia 5.9
import SortFilterProxyModel 0.2

import 'components' as Components
//import './assets/js/cnchar.min.js' as Cnchar
//import './assets/js/pinyin.js' as Pinyin

FocusScope {
    id: root

    FontLoader { id: systemformFont; source: "assets/fonts/BebasNeue.otf" }
    
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
//        console.log('aaaaaaaaaaaa')
//        console.log(Pinyin.getFirstPY('三国'))
        currentHomeIndex = api.memory.get('homeIndex') ?? 0
        currentCollectionIndex = api.memory.get('currentCollectionIndex') ?? 0
        currentPage = api.memory.get('currentPage') ?? 'HomePage'
        collectionListIndex = api.memory.get('collectionListIndex') ?? 0
        collectionSortMode = api.memory.get('collectionSortMode') ?? "title"
        collectionSortDirection =  api.memory.get('collectionSortDirection') ?? 0
        collectionFilterMode =  api.memory.get('collectionFilterMode') ?? "all"
        collectionShowAllItems =  api.memory.get('collectionShowAllItems') ?? false
        startSound.play()                                                                           
    }

    // Collection index
    property var currentCollectionIndex : 0
    property var currentCollection: {
        return allSystems.get(currentCollectionIndex)
    }
  
    function setCollectionIndex(index) {
        //setCollectionListIndex(0)
        api.memory.set('currentCollectionIndex', index)
        currentCollectionIndex = index
    }

    // Collection list index
    property var collectionListIndex : 0
    function setCollectionListIndex(index) {
        api.memory.set('collectionListIndex', index)
        collectionListIndex = index
    }

    // Collection list index
    property var collectionShowAllItems : false
    function setCollectionShowAllItems(show) {
        api.memory.set('collectionShowAllItems', show)
        collectionShowAllItems = show
    }

    // Games index
    property var currentGameIndex: 0
    property var currentGame: {return currentCollection.games.get(currentGameIndex)}
  
    // Main homepage index
    property var currentHomeIndex: 0

    // Collection sort mode
    // Collection list index
    property var collectionSortMode : "title"
    property var collectionSortDirection : 0
    property var collectionFilterMode : "all"

    function setCollectionSortMode(sortMode) {
        api.memory.set('collectionSortMode', sortMode)
        
        var direction = collectionSortDirection == 0 ? 1 : 0
        if (collectionSortMode != sortMode || sortMode == "lastPlayed" || sortMode == "rating")  { 
        
            switch (sortMode) {
                case "title": {
                    direction = 0
                    break
                }
                case "lastPlayed": {
                    direction = 1
                    break
                }
                case "rating": {
                    direction = 1
                    break
                }
                case "release": {
                    direction = 0
                    break
                }
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
  
    property var currentPage : 'HomePage';
    function setCurrentPage(page) {
        api.memory.set('currentPage', page)
        currentPage = page
    }

    property var currentGameDetail : null
    property var currentGameDetailIndex : 0
    property var isShowingGameDetail : false
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
    property var launchingGame : false
    function startGame(game, index) {
        currentGameIndex = index
        setCollectionListIndex(index)       
        launchSound.play()
        launchingGame = true
        delay(400, function() {
            game.launch()
        })  
    }
    
    property var systemColor: {
        if (currentPage === 'GamesPage') {
            return systemColors[currentCollection.shortName] || "#0060A8"
        } else {
            return "#0060A8"
        }
    }

    property var theme : {
        "background": "#F3F3F3",
        "text":"#70000000",
        "title":"#444",
        "background_dark" : "#333333",
        "text_dark":"#DDD",
        "title_dark":"#DDD"
//        "background": "#333333",
//        "text":"#70000000",
//        "title":"#444"
    } 
    
    property var systemColors : {
        "gg"       : "#1886DC",
        "gamegear" : "#1886DC",
        "snes"     : "#AA6AFF",
        "sfc"      : "#920E00",
        "mastersystem"  : "#1886DC",
        "genesis"  : "#1886DC",
        "megadrive"  : "#1886DC",
        "saturn"   : "#1886DC",
        "neogeo"   : "#1499DE",
        "ngp"     : "#FFC205",
        "ngpc"     : "#FFC205",
        "neogeocd"  : "#FFC205",
        "android"  : "#5BFF92",
        "famicom"   : "#920E00",
        "gb"        : "#920E00",
        "gba"      : "#920E00",
        "gbc1"      : "#920E00",
        "gbc"      : "#920E00",
        "pcengine" : "#FF955B",
        "tg16"     : "#FF955B",
        "nes"      : "#920E00",
        "n64"      : "#920E00",
        "nds"      : "#920E00",
        "psp"      : "#00439C",
        "psx"      : "#00439C",
        "ps2"      : "#00439C",
        "sega32x"      : "#1886DC",
        "segacd"      : "#1886DC",
        "dreamcast"   : "#1886DC",
        "cps"         : "#ECAF00",
        "cps1"         : "#ECAF00",
        "cps2"         : "#ECAF00",
        "cps3"         : "#ECAF00",
        "mame"         : "#1673A4",
        "naomi"  : "#FF6701",
        "pgm"  : "#0494CA",
        "wonderswan"  : "#283A86",
        "wonderswancolor"  : "#283A86",
        "pgm"  : "#008FAB",

        "kof"  : "#720D08",
        "mslug"  : "#777",

        "default"     : "#2387FF"
    }
    
    property var systemCompanies: {
        "dreamcast"  : "Sega",
        "gg"         : "Sega",
        "gamegear"   : "Sega",
        "genesis"    : "Sega",
        "megadrive"  : "Sega",
        "saturn"     : "Sega",
        "segacd"     : "Sega",
        "megacd"     : "Sega",
        "mastersystem"  : "Sega",
        "naomi"  : "Sega",
        "sega32x"  : "Sega",
        "neogeo"   : "SNK",
        "neogeocd" : "SNK",
        "ngp"      : "SNK",
        "famicom"       : "Nintendo",
        "gb"       : "Nintendo",
        "gba"      : "Nintendo",
        "gbc"      : "Nintendo",
        "snes"     : "Nintendo",
        "nes"      : "Nintendo",
        "sfc"      : "Nintendo",
        "n64"      : "Nintendo",
        "nds"      : "Nintendo",
        "pcengine" : "NEC",
        "tg16"     : "NEC",
        "psx"      : "Sony",
        "psp"      : "Sony",
        "ps2"      : "Sony",
        "wonderswan"  : "Bandai",
        "wonderswancolor"  : "Bandai",
        "cps"      : "capcom",
        "cps1"      : "capcom",
        "cps2"      : "capcom",
        "cps3"      : "capcom",
        "ngp"     : "snk",
        "ngpc"     : "snk",
        "pgm"  : "igs",
        "mame"  : "arcade",

        "kof" : "snk",
        "mslug" : "snk",
    }

    property var layoutScreen : {
        "width": parent.width,
        "height": parent.height,
        "background": theme.background,      
    }


    property var layoutHeader : {
        "width": layoutScreen.width,
        "height": 40,
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
        if (page == 'HomePage') {
            backSound.play()
        } else {
            forwardSound.play()
        }
        if (page == 'GamesPage') {
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
    
    property int lastPlayedMaximum: {
        if (allLastPlayed.count >= 50) {
            return 50
        } else {
            return allLastPlayed.count
        }
    }

    SortFilterProxyModel {
        id: allSystems
        sourceModel: api.collections
        filters: ValueFilter { roleName: "name"; value: "Android"; inverted: true; }
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
        sorters: RoleSorter { roleName: collectionSortMode; sortOrder: collectionSortDirection == 0 ? Qt.AscendingOrder : Qt.DescendingOrder }
        filters: ValueFilter { roleName: "favorite"; value: true; inverted: false; enabled: collectionFilterMode == "favorites" }
    }

    SortFilterProxyModel {
        id: currentCollectionGamesSorted
        sourceModel: currentCollection.games
        sorters: RoleSorter { roleName: collectionSortMode; sortOrder: collectionSortDirection == 0 ? Qt.AscendingOrder : Qt.DescendingOrder }
    }

    // Primary UI
    Rectangle {
        id: app
        color: theme.background
        width: layoutScreen.width
        height: layoutScreen.height
        anchors.top: parent.top



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
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.left: parent.left
                anchors.rightMargin: 0
                anchors.leftMargin: 0
                opacity: 1.0
                active: isShowingGameDetail
                game: currentGameDetail

                transitions: Transition {
                    NumberAnimation { properties: "opacity"; easing.type: Easing.OutCubic; duration: 1600  }
                } 

            }

        }

        Loader  {
            id: gameDetailLoader
            focus: isShowingGameDetail
            active:  isShowingGameDetail
            anchors.fill: parent
            sourceComponent: gameDetail
            asynchronous: false
        }   
          
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
            NumberAnimation { properties: "opacity"; easing.type: Easing.Out; duration: 350  }
        }            
        z: 2002
    }          
}
