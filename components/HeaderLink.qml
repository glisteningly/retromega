import QtQuick 2.12
import QtGraphicalEffects 1.12

Item {
    property var title : "Row"     
    property var index : 0
    property var selected : currentHomeIndex == index   
    property var lightText : false
    property var textColor : {
        if (activeFocus) {
            return "#ffffff"
        }
        if (selected) {
            if (lightText) {
                return "#ffffff"
            } else {
                return "#000000"
            }
        }
        if (lightText) {
            return "#60ffffff"            
        } else {
            return "#60000000"
        }
        return "#9B9B9B"
    }
    enabled: false
    focus: true
    width: item_text.width
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

    Text {
        id: item_text
        text: title      
//        anchors.left: parent.left
//        anchors.top: parent.top
        anchors.centerIn: parent
        color: textColor
        font.pixelSize: 18
        font.letterSpacing: 3
//        font.bold: true
    }

    Rectangle{
        visible: selected
        id: item_underline
        anchors {
            left: parent.left
            leftMargin: -6
            right: parent.right
            rightMargin: -6
            bottom: parent.bottom
            bottomMargin: 1
        }
        height: 4
        color: theme.primaryColor
//        opacity: 1
//        radius: 6
    }

}
