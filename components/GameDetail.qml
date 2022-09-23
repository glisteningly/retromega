import QtQuick 2.12
import QtGraphicalEffects 1.12
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.15
import "qrc:/qmlutils" as PegasusUtils

Item { 
    id: gameDetail
    property bool active: true
    property var game: null
    property bool pauseScreenshotVideo: false
    //visible: active

    onGameChanged: {
        //console.log(game.assets.video)
    }

    property var meta_mainGenre: {
        if (game.genreList.lenght === 0) { return null }
        var g = game.genreList[0]
        if (g) {
            var s = g.split(',')
            return s[0]
        } else {
            return null
        }
    }
    
    property var meta_players: {
        if (!game) { return null }
        if (game.players > 0) {
            return curDataText.meta_players + game.players
        } else {
            return null
        }
    }

    property var meta_playerGenre : {
        return [meta_players, meta_mainGenre].filter(v => { return v !== null }).join(" • ")
    }

    property var meta_releaseDate: {
        if (!game) { return "" }
        return (game.releaseYear)  ? curDataText.meta_released + game.releaseYear : ""
    }

    property var meta_developedBy: {
        if (!game) { return "" }
        return game.developer
    }

    property var meta_playCount: {
        if (!game) { return "" }
        return curDataText.meta_play_count + game.playCount
    }

    property var meta_playTime: {
        if (!game) { return "" }
        return curDataText.meta_play_time + game.playTime
    }

    property var textColor: {
        return "#AAA"
    }

    property var margin: {
        return vpx(32)
    }

    property var introDescription: {
        if (!game) { return "" }
        return game.description.replace("\n"," ")
    }

    //    property var gameReleased: {
    //        if (!game) {
    //            return ""
    //        } else {
    //            return game.release.subString(0, 4)
    //        }
    //    }

    property var gameIsFavorite: {
        if (game) {
            return game.modelData.favorite
        } else {
            return false
        }
    }
    property var gameScreenshot: {
        if (game) {
            return game.assets.screenshot
        } else {
            return null
        }
    }
    property var gameVideo: {
        if (game) {
            return game.assets.video
        } else {
            return null
        }
    }
    property int textScroll: 10

    Keys.onPressed: {
        if (event.key === '1048586') {
            pauseScreenshotVideo = !pauseScreenshotVideo
        }
        if (api.keys.isCancel(event) && active) {
            event.accepted = true
            showGameDetail(false)
        }
    }

    MouseArea {
        anchors {
            fill: parent
        }
    }

    /**
    * Background
    */
    Rectangle {
        //        color: theme.background_dark
        color: "#88000000"
        anchors {
            fill: parent
        }
    }

    Rectangle {
        id: mainPanel
        color: "#333"
        anchors {
            fill: parent
            //            margins: vpx(100)
            leftMargin: vpx(100)
            rightMargin: vpx(100)
            topMargin: vpx(60)
            bottomMargin: vpx(60)
        }
        opacity: 1.0
        radius: vpx(4)

        Rectangle {
            id: rightPanel
            anchors {
                top: parent.top
                left: parent.left
                leftMargin: parent.width * 0.33
                right: parent.right
                rightMargin: vpx(12)
                bottom: parent.bottom
            }
            //            height: parent.height
            color: "#3A3A3A"
        }
        Rectangle {
            width: vpx(16)
            anchors {
                top: parent.top
                right: parent.right
                bottom: parent.bottom
            }
            //            height: parent.height
            color: "#3A3A3A"
            radius: vpx(12)
        }


    }

    DropShadow {
        anchors.fill: mainPanel
        source: mainPanel
        verticalOffset: vpx(5)
        horizontalOffset: vpx(5)
        color: "#BB000000"
        radius: 20
        samples: 20
    }

    // Content
    FocusScope {
        id: gameDetailContent
        anchors{
            fill: parent
            //            margins: vpx(100)
            leftMargin: vpx(100)
            rightMargin: vpx(100)
            topMargin: vpx(60)
            bottomMargin: vpx(60)
            //            bottom: footer.top
        }
        clip: true
        focus: active
        
        Item {
            id: gameDetailInfo
            anchors {
                fill: parent

            }

            Item {
                id: info_left
                width: parent.width * 0.33 - 2 * margin
                anchors {
                    //                    fill: parent
                    top: parent.top
                    left: parent.left
                    bottom: parent.bottom
                    margins: margin
                    //                    rightMargin: parent.width * 0.33 - margin
                }

                GameScreenshot {
                    id: videoPreview
                    height: info_left.width * 0.75
                    anchors {
                        top: info_left.top
                        left: info_left.left
                        right: info_left.right
                        //                    bottom: actionBtns.top
                        //                    bottomMargin: 20
                    }
                    screenshot: gameScreenshot
                    video: gameVideo
                    active: gameDetail.active
//                    pauseVideo: showFullDescription || pauseScreenshotVideo
                }

                Image {
                    id: imgClearLogo


                    anchors {
                        top: videoPreview.bottom
                        left: info_left.left
                        right: info_left.right
                        //                    bottom: actionBtns.top
                        topMargin: vpx(40)
                    }
                    asynchronous: true
                    visible: source != ""
                    source:  game ? game.assets.logo : ''
                    sourceSize.width: 400
                    sourceSize.height: 400
                    fillMode: Image.PreserveAspectFit
                }

                Item {
                    id: actionBtns
                    width: parent.width
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: vpx(12)
                    ActionButton {
                        id: actionPlay
                        title: curDataText.games_play
                        icon: "system"
                        focus: true
                        height: vpx(45)
                        width: parent.width / 2 - vpx(12)
                        anchors {
                            left: parent.left
                            bottom: parent.bottom
                        }

                        textColor: gameDetail.textColor
                        KeyNavigation.right: actionFavorite
                        Keys.onPressed: {
                            // Start Game
                            if (api.keys.isAccept(event)) {
                                startGame(game.modelData, currentGameDetailIndex)
                            }
                        }
                        onClicked: {
                            startGame(game.modelData, currentGameDetailIndex)
                        }
                    }
                    ActionButton {
                        id: actionFavorite
                        textColor: gameDetail.textColor
                        KeyNavigation.left: actionPlay
                        title: gameIsFavorite ? curDataText.games_favorite_cancel : curDataText.games_favorite
                        icon: gameIsFavorite ? "favorite-on" : "favorite-off"
                        focus: false
                        height: vpx(45)
                        width: parent.width / 2 - vpx(12)
                        anchors {
                            right: parent.right
                            bottom: parent.bottom
                        }
                        Keys.onPressed: {
                            // Favorite
                            if (api.keys.isAccept(event)) {
                                game.modelData.favorite = !game.modelData.favorite
                                event.accepted = true;
                            }
                        }

                        onClicked: {
                            game.modelData.favorite = !game.modelData.favorite
                        }

                    }
                }
            }

            Item {
                id: info_right
                anchors {
                    fill: parent
                    margins: margin
                    leftMargin: parent.width * 0.33 + margin
                }

                Text {
                    id: title
                    font.family: collectionTitleFont.name
                    width: parent.width
                    wrapMode: Text.WordWrap
                    anchors {
                        left: info_right.left
                        top: info_right.top
                    }
                    maximumLineCount: 2
                    text: game ? game.title : curDataText.global_no_games
                    lineHeight: 1.1
                    color: "#DDD"
                    font.pixelSize: vpx(36)
                    font.letterSpacing: 0
                    //                font.bold: true
                    z:2
                }

                Item {
                    id: game_meta
                    height: vpx(40)
                    anchors {
                        top: title.bottom
                        topMargin: vpx(4)
                        left: parent.left
                        right: parent.right
                    }
                    Text {
                        id: game_meta_developer
                        text: meta_developedBy
                        font {
                            pixelSize: vpx(18)
                            family: collectionTitleFont.name
                        }
                        wrapMode: Text.WordWrap
                        elide: Text.ElideRight
                        horizontalAlignment: Text.AlignJustify
                        color: textColor
                    }

                    Text {
                        id: game_meta_released
                        text: meta_releaseDate
                        anchors {
                            left: game_meta_developer.right
                            leftMargin: vpx(24)
                        }
                        font {
                            pixelSize: vpx(18)
                            family: collectionTitleFont.name
                        }
                        horizontalAlignment: Text.AlignJustify
                        color: textColor
                    }

                    Text {
                        id: game_meta_players
                        text: meta_players
                        anchors {
                            top: parent.top
                            topMargin: vpx(30)
                        }
                        font {
                            family: collectionTitleFont.name
                            pixelSize: vpx(18)
                        }
                        horizontalAlignment: Text.AlignJustify
                        color: textColor
                    }

                    Text {
                        id: game_meta_play_count
                        text: meta_playCount
                        anchors {
                            top: parent.top
                            topMargin: vpx(30)
                            left: game_meta_players.right
                            leftMargin: vpx(24)
                        }
                        font {
                            family: collectionTitleFont.name
                            pixelSize: vpx(18)
                        }
                        horizontalAlignment: Text.AlignJustify
                        color: textColor
                    }

                    //                    Text {
                    //                        id: game_meta_play_time
                    //                        text: meta_playTime
                    //                        anchors {
                    //                            top: parent.top
                    //                            topMargin: vpx(30)
                    //                            left: game_meta_play_count.right
                    //                            leftMargin: vpx(24)
                    //                        }
                    //                        font {
                    //                            pixelSize: vpx(18)
                    //                        }
                    //                        horizontalAlignment: Text.AlignJustify
                    //                        color: textColor
                    //                    }
                }

                //Description
                Item {
                    width: parent.width
                    //                    height: gameDetailText.height - 40
                    anchors {
                        top: game_meta.bottom
                        topMargin: vpx(40)
                        left: parent.left
                        right: parent.right
                        bottom: parent.bottom
                    }

                    PegasusUtils.AutoScroll {
                        anchors.fill: parent
                        Text {
                            id: txt_game_description
                            width: parent.width
                            text: introDescription
                            font {
                                family: collectionTitleFont.name
                                pixelSize: vpx(22)
                            }
                            wrapMode: Text.WordWrap
                            elide: Text.ElideRight
                            horizontalAlignment: Text.AlignJustify
                            color: "#AAA"
                        }
                    }
                }


            }
        }

        Item {
            id: close
            width: vpx(64)
            height: vpx(64)
            anchors {
                top: parent.top
                right: parent.right
            }
            TapButton {
                iconSize: vpx(32)
                iconImage: "../assets/icons/ic-close.svg"
                bgColor: "#22000000"
                onClicked: showGameDetail(false)
            }
        }
    }

    GameDetailFooter {
        id: footer
        anchors.bottom: parent.bottom
    }
}
