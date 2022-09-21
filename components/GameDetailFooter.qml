import QtQuick 2.12

Item {
    anchors {
        left: parent.left
        right: parent.right
    }
    height: vpx(44)
    Rectangle {
        id: footer
        width: vpx(200)
        color: "#AA000000"
        height: parent.height
        anchors {
            right: parent.right
            rightMargin: vpx(12)
            bottom: parent.bottom
            bottomMargin: vpx(12)
        }
        radius: vpx(6)
        clip:true

        ButtonLegend {
            id: button_legend_a
            title: curDataText.global_select
            key: "A"
            width: vpx(55)
            anchors {
                right: button_legend_b.left
                rightMargin: vpx(32)
                verticalCenter: parent.verticalCenter
            }
        }

        ButtonLegend {
            id: button_legend_b
            title: curDataText.global_back
            key: "B"
            width: vpx(55)
            anchors {
                right: parent.right
                rightMargin: vpx(32)
                verticalCenter: parent.verticalCenter
            }
        }
    }
}
