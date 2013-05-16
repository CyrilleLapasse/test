import QtQuick 1.1
import fqw.internal 1.0

Item {
    id: widget;

    property string label: ""
    focus: true;

    property int keyPresses;

    // Default size
    implicitWidth: 135
    implicitHeight: 40

    StandardAsset {
        id: background;
        anchors.fill: parent
        background: (widget.activeFocus ? "990000" : "333333");
        border: "FF0000";
    }

    Text {
        id: text

        text: (
            "<b>" + widget.label + "</b><br />" +
            (widget.focus ? "+" : "!") + "focus<br />" +
            (widget.activeFocus ? "+" : "!") + "activeFocus<br/>" +
            "Key press count:" + widget.keyPresses
        )
        font.pixelSize: 20
        smooth: true
        color: "white";
        anchors.centerIn: parent;
    }

    Keys.onPressed: {
        keyPresses++;
    }
}
