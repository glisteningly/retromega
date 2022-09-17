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
            height:vpx(24)
            width:vpx(24)
            color:"#EEE"
            radius:vpx(12)
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
                 font.pixelSize: vpx(18)
//	             font.letterSpacing: -0.3
	             font.bold: true              
                 anchors.verticalCenter: parent.verticalCenter
	             anchors.horizontalCenter: parent.horizontalCenter
	        }
	        Text{
	        	 id: legend_title
	             text: title
//	             color: lightText ? "#70ffffff" : theme.text
                 color: "#EEE"
                 font {
                     pixelSize: vpx(20)
//                     letterSpacing: 1
                     family: systemSubitleFont.name
                     bold: true
                 }
	             anchors.verticalCenter: parent.verticalCenter
	             anchors.left: parent.right
                 anchors.leftMargin: vpx(4)
	             
	        }
	    }
	}
}
