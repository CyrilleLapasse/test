import QtQuick 1.1
import fqw.menu 1.0

Item {
    property alias text: textItem.text

    height: 80

    Text {
        id: textItem
        color: "white"
        font.pixelSize: parent.height * .4
        font.italic: true

        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right
        elide: Text.ElideRight
    }
}
