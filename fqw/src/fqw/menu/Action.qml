import QtQuick 1.1
import fqw.menu 1.0

Item {
    id: widget
    enabled: true

    signal clicked()

    property alias text: textItem.text

    Text {
        id: textItem
        color: widget.enabled ? "white" : "gray"
        font.pixelSize: parent.height / 2

        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.right: parent.right
        elide: Text.ElideRight
    }

    Keys.onPressed: {
        switch (event.key) {
        case Qt.Key_Return:
        case Qt.Key_Enter: {
            clicked();
            event.accepted = true;
        }
        }
    }
}
