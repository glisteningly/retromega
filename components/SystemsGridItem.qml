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
    id: root

    property bool selected: false
    property var collection

    property alias imageWidth: imgController.paintedWidth
    property alias imageHeight: imgController.paintedHeight

    signal clicked()
    signal doubleClicked()

    scale: selected ? 1.1 : 1
    z: selected ? 3 : 1


    Behavior on scale { PropertyAnimation { duration: 150 } }

    Rectangle {
        id: gridItemBg
        color:  systemColors[modelData.shortName] ?? "#000000"
        opacity: 0.5
        anchors.fill: parent
        anchors.margins: 2
//            scale: 1.1
        radius: vpx(12)
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
            leftMargin: 5
            rightMargin: 5
            bottomMargin: 10
        }
        asynchronous: true
        visible: source != ""
        source:  "../assets/images/devices/"+modelData.shortName+".png" || ""
        sourceSize { width: 128; height: 128 }
        fillMode: Image.PreserveAspectFit
        smooth: true
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
        opacity: selected ? 1.0 : 0.6
        width: parent.width
//        anchors.centerIn: parent.bottom
//        anchors.leftMargin: 8
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        font.letterSpacing: 0.2


        text: collection.name.length >= 18 ? collection.shortName : collection.name
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter
        color: "#eee"
        font {
            pixelSize: vpx(32)
            family: systemTitleFont.name
        }
    }

    DropShadow {
        visible: selected
        anchors.fill: shortTitle
        source: shortTitle
        verticalOffset: 0
        horizontalOffset: 0
        color: "#90000000"
        radius: 20
        samples: 30
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()
        onDoubleClicked: root.doubleClicked()
    }
}
