import QtQuick 2.12
import QtGraphicalEffects 1.12

Item {
    property var title : "Row"
    property var icon : ""
    property var index : 0
    property var selected : currentHomeIndex == index
    property var lightText : false
    property var textColor : {
        if (activeFocus) {
            return "#ffffff"
        }
        if (selected) {
            return "#ffffff"
        } else {
            return "#60ffffff"
        }
    }

    enabled: false
    focus: true
    width: selected? iconImage.width + item_text.width + vpx(4) : iconImage.width
    height: parent.height

    Keys.onPressed: {
        if (api.keys.isAccept(event)) {
            event.accepted = true
            setHomeIndex(index)
            navSound.play()
        }
    }

    //    HeaderSelection {
    //        anchors.left: parent.left
    //        anchors.top: parent.top
    //        anchors.topMargin: -8
    //        anchors.bottomMargin: -8
    //        anchors.rightMargin: -8
    //        anchors.fill: parent
    //        width:parent.width
    //        height:parent.height
    //        visible: parent.activeFocus ? true : false
    //    }

    //    Rectangle {
    //        id: bg
    //        color: "#33000000"
    //        visible: selected
    //        anchors {
    //            fill: parent
    //        }
    //    }

    Image {
        id: iconImage
        width: vpx(55)
        height: vpx(28)
        fillMode: Image.PreserveAspectFit
        source: "../assets/icons/ic-" + icon + ".svg"
        anchors {
            verticalCenter: parent.verticalCenter
//            horizontalCenter: parent.horizontalCenter
            left: parent.left
        }
        opacity: selected? 1 : 0.3
        //        anchors {
        //            fill: parent
        //            leftMargin: vpx(20)
        //            rightMargin: vpx(20)
        //        }
    }

    Text {
        id: item_text
        text: title
        visible: selected
        //        anchors.left: parent.left
        //        anchors.top: parent.top
        anchors {
            //            centerIn: parent
            verticalCenter: parent.verticalCenter
            verticalCenterOffset: -1
            left: iconImage.right
            leftMargin: vpx(-6)
        }

        color: textColor
        font {
            //            family: boldTitleFont
            pixelSize: vpx(22)
            letterSpacing: boldTitleLetterSpacing
            //        bold: true
        }
    }

    //    Text {
    //        id: item_text
    //        text: title
    ////        anchors.left: parent.left
    ////        anchors.top: parent.top
    //        anchors.centerIn: parent
    //        color: textColor
    //        font {
    //            family: boldTitleFont
    //            pixelSize: vpx(24)
    //            letterSpacing: boldTitleLetterSpacing
    ////        bold: true
    //        }
    //    }
}
