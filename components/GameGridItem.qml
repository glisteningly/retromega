// Pegasus Frontend
// Copyright (C) 2017-2018  Mátyás Mustoha
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.


import QtQuick 2.2
import QtGraphicalEffects 1.12
import "qrc:/qmlutils" as PegasusUtils


Item {
    id: gameGridItem
    property bool rounded: true
//    focus: true

    property bool selected: false
    property var gameData

    property var highlightColor: {
        if (currentHomeIndex > 1) {
            return theme.primaryColor
        } else {
            return systemColors[currentCollection.shortName] ?? theme.primaryColor
        }
    }

    property alias imageWidth: imgGridItem.paintedWidth
    property alias imageHeight: imgGridItem.paintedHeight

    property int titlefontSize: 20

    signal clicked()
    signal doubleClicked()
    signal imageLoaded(int imgWidth, int imgHeight)

//    property var scale_normal: Scale { origin.x: 0; origin.y: 0; xScale: 1; yScale: 1}
//    property var scale_zoomed: Scale { origin.x: 0; origin.y: 0; xScale: 1.1; yScale: 1.1}

    scale: selected ? 1.1 : 1
//    transform: selected ? scale_zoomed : scale_normal
    z: selected ? 3 : 1

    Behavior on scale { PropertyAnimation { duration: 150 } }

    Rectangle {
        id: gridItemBg
//        color: highlightColor
        color: "#333"
        visible: selected
//        color:  systemColors[modelData.shortName] ?? "#000000"
//        opacity: headerFocused ? 0.1 : 0.3
        anchors.fill: parent
//        anchors.margins: 0

//        opacity: 1
//        SequentialAnimation on color {
//            loops: Animation.Infinite

//            ColorAnimation {
//                from: "white"
//                to: "#30000000"
//                duration: 400
//            }
//            ColorAnimation {
//                from: "#30000000"
//                to: "white"
//                duration: 400
//            }
//        }

        border.color: "white"
        border.width: 2
        SequentialAnimation on border.color {
            loops: Animation.Infinite

            ColorAnimation {
                from: "white"
                to: "#30000000"
                duration: 400
            }
            ColorAnimation {
                from: "#30000000"
                to: "white"
                duration: 400
            }
        }
    }

    DropShadow {
        visible: selected
        anchors.fill: gridItemBg
        source: gridItemBg
        verticalOffset: 3
        horizontalOffset: 3
        color: "#CC000000"
        radius: 20
        samples: 20
    }

    Image {
        id: imgGridItem
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: parent.bottom
            margins: 2
//            topMargin: 0
//            rightMargin: 10
//            bottomMargin: 0
//            leftMargin: 10
        }
        asynchronous: true
        visible: source != ""
        source:  modelData.assets.boxFront || ""
        sourceSize { width: 240; height: 240 }
        fillMode: Image.PreserveAspectFit
        smooth: true
//        property bool adapt: true

        // 圆角
//        layer.enabled: rounded
//        layer.effect: OpacityMask {
//            maskSource: Item {
//                width: gameGridItem.width
//                height: gameGridItem.height

//                Rectangle {
//                    anchors.fill: parent
//                    radius: 6
//                }
//            }
//        }

        onStatusChanged: {
            if (status === Image.Ready) {
                gameGridItem.imageLoaded(implicitWidth, implicitHeight);
            }
        }
    }

//    Image {
//        anchors.centerIn: parent

//        visible: imgGridItem.status === Image.Loading
//        source: '../assets/images/loading-spinner.png'

//        RotationAnimator on rotation {
//            loops: Animator.Infinite;
//            from: 0;
//            to: 360;
//            duration: 500
//        }
//    }
    Rectangle {
        id: noImage
        visible: !imgGridItem.visible
        color:  "#20FFFFFF"
        anchors {
            fill: parent
            margins: 2
//            left: parent.left
//            right: parent.right
//            top: parent.top
//            bottom: parent.bottom

//            leftMargin: 6
//            rightMargin: 6
//            topMargin: 6
//            bottomMargin: 24
        }
//        radius: 4
            Text {
                visible: !selected
                width: parent.width - vpx(12)
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: vpx(12)
                    rightMargin: vpx(12)
                    centerIn: parent
                }
                text: modelData.title
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
                color: '#90FFFFFF'
                elide: Text.ElideMiddle
                maximumLineCount:3
                font {
                    pixelSize: vpx(20)
                    letterSpacing: 0.5
                }
            }
    }

//    Text {
//        visible: !selected
//        height: titlefontSize + vpx(6)
//        anchors {
//            left: parent.left
//            right: parent.right
//            bottom: parent.bottom
//            leftMargin: 6
//            rightMargin: 6
//            bottomMargin: vpx(4)
//        }
//        text: modelData.title
//        wrapMode: Text.NoWrap
//        horizontalAlignment: Text.AlignHCenter
//        color: selected ? "white" : '#90FFFFFF'
//        elide: Text.ElideMiddle
//        maximumLineCount:1
//        font {
//            pixelSize: titlefontSize
//            letterSpacing: 0.5
//        }
//    }

    PegasusUtils.AutoScroll {
        visible: selected
        height: titlefontSize + vpx(14)
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
//            margins: 0
            leftMargin: 2
            rightMargin: 2
            bottomMargin: -2.5
        }
        Rectangle {
            color:  "#90000000"
            anchors {
                fill: parent

            }
        }

        Text {
            width: parent.width
            text: modelData.title
            font {
                pixelSize: titlefontSize
                letterSpacing: 0.5
            }
            wrapMode: Text.WordWrap
            elide: Text.ElideMiddle
            horizontalAlignment: Text.AlignHCenter
            color: "white"
        }
    }

    Image {
        width: vpx(40)
        height: vpx(40)
        visible: modelData.favorite && !hideFavoriteIcon
//        fillMode: Image.PreserveAspectFit
        source: "../assets/icons/favorite_red.png"
        asynchronous: true
        anchors {
            right: parent.right
            top: parent.top
            rightMargin: 3
            topMargin: 3
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: gameGridItem.clicked()
        onDoubleClicked: gameGridItem.doubleClicked()
    }
}
