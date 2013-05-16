import QtQuick 1.1
import fqw.control 1.0
import fqw.menu 1.0

Item {
    property alias exclusiveGroup: cb.exclusiveGroup
    property alias text: cb.text
    property alias value: cb.value
    property alias checked: cb.checked
    enabled: true

    signal clicked()

    CheckBox {
        focus: true
        id: cb
        enabled: parent.enabled
        __show_bg: false
        anchors.fill: parent

        onClicked: parent.clicked()
    }
}
