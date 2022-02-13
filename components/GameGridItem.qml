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

    signal clicked()
    signal doubleClicked()
    signal imageLoaded(int imgWidth, int imgHeight)

    scale: selected ? 1.1 : 1
    z: selected ? 3 : 1

    Behavior on scale { PropertyAnimation { duration: 150 } }

    Rectangle {
        id: gridItemBg
        color: highlightColor
        visible: selected
//        color:  systemColors[modelData.shortName] ?? "#000000"
//        opacity: headerFocused ? 0.1 : 0.3
//        opacity: 0.8
        anchors.fill: parent
        anchors.margins: 2
//            scale: 1.1
        radius: 4
//        clip: true
//            z: 2
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
            leftMargin: 6
            rightMargin: 6
            topMargin: 6
            bottomMargin: 24
        }
        asynchronous: true
        visible: source != ""
        source:  modelData.assets.boxFront || ""
        sourceSize { width: 160; height: 160 }
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
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: parent.bottom
            leftMargin: 6
            rightMargin: 6
            topMargin: 6
            bottomMargin: 24
        }
        radius: 4
    }

    Text {
        height: 20
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            leftMargin: 6
            rightMargin: 6
            bottomMargin: 5
        }
        text: modelData.title
        wrapMode: Text.NoWrap
        horizontalAlignment: Text.AlignHCenter
        color: selected ? "white" : '#90FFFFFF'
        elide: Text.ElideMiddle
        maximumLineCount:1
        font {
            pixelSize: 14
            letterSpacing: 0.5
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: gameGridItem.clicked()
        onDoubleClicked: gameGridItem.doubleClicked()
    }
}
