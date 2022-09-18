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
import '../assets/js/colorDetector.js' as ColorDetector


Item {
    id: root

    property bool selected: false
    property var collection

    property alias imageWidth: imgController.paintedWidth
    property alias imageHeight: imgController.paintedHeight

    signal clicked()
    signal doubleClicked()

    scale: selected ? 1.1 : 1
    z: selected ? 3 : 1

    Behavior on scale {
        PropertyAnimation { duration: 150 }
    }

    Behavior on width {
        NumberAnimation { duration: 100; }
    }

    Behavior on height {
        NumberAnimation { duration: 100; }
    }

    Rectangle {
        id: gridItemBgBorder
        visible: selected
        anchors {
            fill: parent
        }
        color: "transparent"
        border.color: "white"
        border.width: 2
        SequentialAnimation on border.color {
            loops: Animation.Infinite

            ColorAnimation {
                from: "white"
                to: "#30000000"
                duration: 600
            }
            ColorAnimation {
                from: "#30000000"
                to: "white"
                duration: 600
            }
        }
    }

    Rectangle {
        id: gridItemBg
        color:  collectionInfoList[modelData.shortName].color || "#000000"
        opacity: 0.6
        anchors.fill: parent
        anchors.margins: 2
//            scale: 1.1
//        radius: vpx(8)
//            z: 2
    }

    DropShadow {
        visible: selected
        anchors.fill: gridItemBg
        source: gridItemBg
        verticalOffset: 3
        horizontalOffset: 3
        color: "#90000000"
        radius: 10
        samples: 20
    }

    Image {
        id: imgController
        anchors {
            fill: parent
//            margins: vpx(5)
            leftMargin: parent.width * 0.15
            rightMargin: parent.width * 0.15
            bottomMargin: parent.height * 0.1
        }
        asynchronous: true
        visible: source != ""
        source:  "../assets/images/collections/"+modelData.shortName+".png" || ""
        sourceSize { width: 256; height: 256 }
        fillMode: Image.PreserveAspectFit
//        smooth: true
    }

//    Image {
//        anchors.centerIn: parent

//        visible: boxFront.status === Image.Loading
//        source: "../assets/loading-spinner.png"

//        RotationAnimator on rotation {
//            loops: Animator.Infinite;
//            from: 0;
//            to: 360;
//            duration: 500
//        }
//    }

    Text {
        id: shortTitle
//        visible: selected
        opacity: selected ? 1.0 : 0.85
        width: parent.width
//        anchors.centerIn: parent.bottom
//        anchors.leftMargin: 8
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height * 0.06
        font.letterSpacing: 1.5
        text: collection.name
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter
//        color: ColorDetector.isColorDarkOrLight(collectionInfoList[modelData.shortName].color) === 'dark'? "#eee":"#333"
        color: "#EEE"
        font {
            pixelSize: parent.width * 0.1
            family: collectionTitleFont.name
        }
    }

//    DropShadow {
//        visible: selected
//        anchors.fill: shortTitle
//        source: shortTitle
//        verticalOffset: 0
//        horizontalOffset: 0
//        color: "#90000000"
//        radius: 20
//        samples: 20
//    }
//    Glow {
//        anchors.fill: shortTitle
//        visible: selected
//        radius: 8
//        samples: 17
//        color: "#30000000"
//        source: shortTitle
//    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()
        onDoubleClicked: root.doubleClicked()
    }
}
