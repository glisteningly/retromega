import QtQuick 2.12

Item {
	property var title : "Title"
	property var key : "X"
	property var lightText : false
	//property alias leftMargin : legend_container.leftMargin

	Rectangle {
		id: legend_container
	    anchors.verticalCenter: parent.verticalCenter
	    anchors.left: parent.left
	    anchors.leftMargin: 0
	    //anchors.leftMargin: 70
	    Rectangle{
	    	id: legend
            height: vpx(20)
            width: vpx(32)
            color:"#EEE"
            radius: vpx(4)
	        anchors.verticalCenter: parent.verticalCenter
	        anchors.left: parent.left  
	        anchors.leftMargin: 0
//            border {
//                width: vpx(1)
//                color: "#444"
//            }

	        Text{
	             text: key
                 color: "#222"
                 font.pixelSize: vpx(14)
                 font.letterSpacing: 0
	             font.bold: true              
	             anchors.verticalCenter: parent.verticalCenter
	             anchors.horizontalCenter: parent.horizontalCenter
	        }
	        Text{
	        	 id: legend_title
	             text: title
                 color: "#EEE"
                 font {
                     family: systemSubitleFont.name
                     pixelSize: vpx(20)
//                     letterSpacing: 1
                 }
	             anchors.verticalCenter: parent.verticalCenter
	             anchors.left: parent.right
                 anchors.leftMargin: vpx(6)
	        }
	    }
	}
}
