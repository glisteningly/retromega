import QtQuick 2.12
import QtGraphicalEffects 1.12

Item {
    id: root
    property string title : "Row"
    property string icon : ""
    property int index : 0
    property bool selected : currentHomeIndex === index
    property bool lightText : false
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
    signal clicked()

//    enabled: false
//    focus: false
    width: selected? iconImage.width + item_text.width + vpx(4) : iconImage.width + vpx(12)
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
//            verticalCenterOffset: -1
            left: iconImage.right
            leftMargin: vpx(-6)
        }

        color: textColor
        font {
            family: boldTitleFont
            pixelSize: vpx(22)
            letterSpacing: boldTitleLetterSpacing
            //        bold: true
        }
    }

    TapHandler {
        gesturePolicy: TapHandler.ReleaseWithinBounds
        onTapped: clicked()
    }
}
