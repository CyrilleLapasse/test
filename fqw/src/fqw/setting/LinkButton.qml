import QtQuick 1.1
import fqw.util 1.0
import fqw.control 1.0
import fqw.indicator 1.0
import "."

Item {
    id: self

    property alias buttonText: button.text

    signal clicked

    Button {
        id: button

        text: enabled ? "Cliquez sur OK   " : "";
        implicitWidth: 250;
        __glow: false
        __bold: false
        __backgroundShown: enabled
    
        PlayerStatus {
            status: "play";
            anchors.right: parent.right;
            anchors.rightMargin: 5;
            anchors.verticalCenter: parent.verticalCenter;
            height: parent.height / 3;
        }
    
        Keys.onRightPressed: clicked();

        onClicked: self.clicked()
    }
}

