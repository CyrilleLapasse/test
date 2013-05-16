import QtQuick 1.1
import fqw.indicator 1.0

ProgressBar {
    id: widget;

    /*** Public API */

    property alias status: playerStatus.status;
    property string endTimeLabel: "";
    property string currentTimeLabel: "";
    property string nameLabel: "";

    // Inherited from ProgressBar:
    //   min, max, value, reset(), preloadValue

    /*** Private */

    Item {
        id: inner;
        anchors.fill: parent;
        anchors.margins: parent.margin;

        PlayerStatus {
            id: playerStatus;
    
            anchors.left: parent.left;
            anchors.leftMargin: 5;
            anchors.verticalCenter: parent.verticalCenter;
            height: parent.height / 2;
            width: parent.height / 2;
        }
    
        Text {
            id: name;
    
            anchors.left: playerStatus.right;
            anchors.leftMargin: 5;
            anchors.right: current.left;
            anchors.verticalCenter: parent.verticalCenter;
    
            text: widget.nameLabel;
            elide: Text.ElideRight;
            styleColor: "black";
            visible: widget.nameLabel != "";
            font.pixelSize: widget.height / 2;
            color: "white";
        }
    
        Text {
            id: current;
    
            anchors.right: end.left;
            anchors.verticalCenter: parent.verticalCenter;
    
            styleColor: "black";
            text: widget.currentTimeLabel;
            visible: widget.currentTimeLabel != "";
            font.pixelSize: widget.height / 2;
            color: "#eee";
        }
    
        Text {
            id: end;
    
            anchors.right: parent.right;
            anchors.rightMargin: 4;
            anchors.verticalCenter: parent.verticalCenter;
    
            styleColor: "black";
            text: widget.endTimeLabel;
            visible: widget.endTimeLabel != "";
            font.pixelSize: widget.height / 2;
            color: "white";
        }
    }
}
