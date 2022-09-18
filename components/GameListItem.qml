import QtQuick 2.12
import QtGraphicalEffects 1.12

Item {
    id: root
    property string title : "Row"
    property bool selected : false
    property bool favorite : false
    property string rowColor : "#000000"
    property bool emptyStyle : false
    property var model : null
    property var collectionName : {
        return model? model.collections.get(0).shortName : null
        //        return _coll? systemInfoList[_coll].short : ''
    }

    signal clicked()

    Rectangle {
        id: rowBg
        anchors {
            fill: parent
            margins: vpx(2)
        }
        color: "#33000000"
    }

    Rectangle {
        width:parent.width
        height:parent.height
        anchors {
            fill: parent
            margins: vpx(2)
        }
        visible: selected
        color: "#333"
        border {
            width: vpx(1)
            color: "#DDD"
        }
        SequentialAnimation on border.color {
            loops: Animation.Infinite

            ColorAnimation {
                from: "#DDD"
                to: "#30000000"
                duration: 600
            }
            ColorAnimation {
                from: "#30000000"
                to: "#DDD"
                duration: 600
            }
        }
    }

    Text {
        //        text: model.collections.get(0).shortName
        text: model.title
        color: selected ? "#DDD" : "#888"
        //		opacity: emptyStyle ? 0.3 : 1.0
        font {
            family: boldTitleFont
            pixelSize: vpx(24)
//            letterSpacing: 0.5
            //        bold: false
        }
        width: parent.width - (favorite ? vpx(50) : vpx(12))
        height: parent.height
        anchors {
            left: parent.left
            leftMargin: vpx(15)
            verticalCenter: parent.verticalCenter
            verticalCenterOffset: vpx(-1)
        }
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    // show game platform except from systemlist
    Item {
        id: sysTagContainer
        visible: currentHomeIndex !== 0
        height: vpx(22)
        width: sysTag.width + vpx(12)
        anchors {
            right: parent.right
            rightMargin: vpx(30)
            verticalCenter: parent.verticalCenter
        }

        //        Rectangle {
        //            anchors {
        //                fill: parent
        //            }
        //            color: systemInfoList[collectionName].color || "#666"
        //            radius: vpx(4)
        //        }
        Text {
            id: sysTag

            text: collectionName ? systemInfoList[collectionName].short.toUpperCase() : ''
            color: systemInfoList[collectionName].color || "#666"
            //            color: "#EEE"
            font {
                family: systemTitleFont.name
                pixelSize: vpx(20)
                letterSpacing: vpx(0.5)
            }
            //        width: parent.width
            height: parent.height
            anchors {
                right: parent.right
//                rightMargin: vpx(6)
                verticalCenter: parent.verticalCenter
                verticalCenterOffset: vpx(1)
            }
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
            elide: Text.ElideRight
        }
    }

    Image {
        width: vpx(36)
        height: vpx(36)
        visible: favorite
        fillMode: Image.PreserveAspectFit
        source: "../assets/icons/ic-list-favorite.png"
        asynchronous: true
        anchors {
            top: parent.top
            topMargin: vpx(3)
            right: parent.right
            rightMargin: vpx(3)

        }
    }

    //    Image {
    //        width: vpx(20)
    //        height: vpx(20)
    //        visible: favorite
    //        fillMode: Image.PreserveAspectFit
    //        source: "../assets/icons/ic-list-favorite"
    //        asynchronous: true
    //        anchors {
    //            right: parent.right
    //            rightMargin: vpx(3)
    //            verticalCenter: parent.verticalCenter
    //        }
    //    }
    TapHandler {
        onTapped: root.clicked()
    }
}
