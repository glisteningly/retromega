import QtQuick 2.12

Item {
    property var title: ""
    property var light: false
    property var lightActive: false
    anchors {
        left: parent.left
        right: parent.right
    }
    height: vpx(44)
    Rectangle {
        id: footer
        width: vpx(292)
        color: "#88000000"
        height: parent.height
        anchors {
            right: parent.right
            rightMargin: vpx(12)
            bottom: parent.bottom
            bottomMargin: vpx(12)
        }
        radius: vpx(6)
        clip:true

        Text {
            id: countNum
            text: title
            anchors {
                left: parent.left
                leftMargin: vpx(16)
                verticalCenter: parent.verticalCenter
            }
            font {
                family: collectionTitleFont.name
                pixelSize: vpx(20)
                letterSpacing: 0.3
            }
            color: "#EEE"
            elide: Text.ElideRight
        }


        ButtonLegend {
            id: button_legend_a
            title: curDataText.global_enter
            key: "A"
            width: vpx(55)
            lightText: lightActive
            anchors {
                right: button_legend_sel.left
                rightMargin: vpx(32)
                verticalCenter: parent.verticalCenter
            }
        }

//        ButtonLegend {
//            id: button_legend_b
//            title: curDataText.global_menu
//            key: "B"
//            width: vpx(55)
//            lightText: lightActive
//            anchors {
//                right: button_legend_sel.left
//                rightMargin: vpx(32)
//                verticalCenter: parent.verticalCenter
//            }
//        }

        ButtonLegendSquare {
            //      visible: currentHomeIndex !== 1
            id: button_legend_sel
            title: curDataText.global_view
            key: "SEL"
            width: vpx(55)
            lightText: lightActive
            anchors {
                right: parent.right
                rightMargin: vpx(38)
                verticalCenter: parent.verticalCenter
            }
        }

    }
}
