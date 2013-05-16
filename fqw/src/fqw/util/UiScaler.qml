import QtQuick 1.1

Item {
    objectName: "fqw.util.UiScaler"

    anchors.centerIn: parent

    property int uiHeight: 720

    width: parent.width / (parent.height / uiHeight)
    height: uiHeight
    scale: parent.height / uiHeight
}

