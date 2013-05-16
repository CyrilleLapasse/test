import QtQuick 1.1
import fqw.indicator 1.0
import fqw.control 1.0

Rectangle {
    width: 270
    height: 80

    Label {
        id: l0
        text: "Line 0"
        anchors.top: parent.top
        anchors.right: parent.horizontalCenter
    }

    Label {
        text: "Line 1"
        anchors.top: l0.bottom
        anchors.right: parent.horizontalCenter
    }

    Button {
        id: b0
        text: "Button 0"
        anchors.top: parent.top
        anchors.left: parent.horizontalCenter
    }

    Button {
        text: "Button 1"
        anchors.top: b0.bottom
        anchors.left: parent.horizontalCenter
    }
}
