import QtQuick 2.12
import QtGraphicalEffects 1.12

Item {
    id: pageIndicator
    Row {
        spacing: 10
        Repeater {
            model: pageIndicator.pageCount
            Rectangle {
                width: vpx(6)
                height: vpx(6)
                radius: vpx(3)
                color: pageIndicator.currentIndex == index ? "white" : "#20ffffff"
            }
        }
    }
    width:  pageIndicator.pageCount * vpx(6 + 10)
    property var currentIndex: 0
    property int pageCount: 10

}
