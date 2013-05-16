import QtQuick 1.1
import fqw.control 1.0

Dialog {
    id: self;

    property alias text: label.text
    buttons: ["OK"]

    property Text _sizer: Text {
        id: sizer
        opacity: 0
        font: label.font
        text: label.text
    }

    Text {
        id: label

        anchors.horizontalCenter: parent.horizontalCenter
        width: (sizer.width > 800) ? 800 : sizer.width

        font.pixelSize: 25

        color: "white"
        text: ""
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.Wrap
    }
}
