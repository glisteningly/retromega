import QtQuick 2.12

Item {
  property var title: ""
  property var light: false
  property var lightActive: false
  anchors {
    left: parent.left
    right: parent.right
  }
  height: 40
  Rectangle {
    id: footer
    //color: light ? "#60000000" : "transparent"
    color: "#F3F3F3"
    height: parent.height  
    anchors {
      left: parent.left
      right: parent.right
      leftMargin: 0
      rightMargin: 0
    }
    clip:true


//    Rectangle {
//        anchors.leftMargin: 22
//        anchors.rightMargin: 22
//        anchors.left: parent.left
//        anchors.right: parent.right
//        color: lightActive ? "#20ffffff" : "#20000000"
//        anchors.top: parent.top
//        height: 1
//    }


    // CustomBorder {
    //   leftMargin: 22
    //   rightMargin: 22
    //   width: parent.width 
    //   height: parent.height
    //   lBorderwidth: 0
    //   rBorderwidth: 0
    //   tBorderwidth: 1
    //   bBorderwidth: 0
    //   color: wrapperCSS.background
    //   borderColor: "#e3e3e3"
    // }

    Text{
      text: title
      font.family: systemSubitleFont.name
      anchors.right: parent.right
      anchors.rightMargin: 32
      color: "#9B9B9B"
      font.pixelSize: 18
      font.letterSpacing: 0.3
//      font.bold: true
      anchors.verticalCenter: parent.verticalCenter
      elide: Text.ElideRight   
      height: 20
    }

 
    ButtonLegend {
      id: button_legend_a
      title: "选择"
      key: "A"
      width: 55
      lightText: lightActive
      anchors.left: parent.left
      //anchors.left: button_legend_x.right
      anchors.leftMargin: 32
      anchors.verticalCenter: parent.verticalCenter
    }      

   ButtonLegend {
      id: button_legend_x
      title: "菜单"
      key: "B"
      width: 55
      lightText: lightActive
      anchors.left: button_legend_a.right
      anchors.leftMargin: 24
      anchors.verticalCenter: parent.verticalCenter
    }

  }
}
