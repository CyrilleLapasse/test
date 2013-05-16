import QtQuick 1.1
import fqw.internal 1.0

ListView {
    id: listView

    signal selected(int index)

    delegate: FocusScope {
        id: self

        signal clicked()

        property string text: title

        enabled: true

        clip: true

        /*** Private */

        implicitWidth: 135
        implicitHeight: 40

        property bool current: ListView.isCurrentItem
        property bool hovered: ListView.isCurrentItem || (
                mouse.containsMouse && self.enabled)
        property bool pressed: false
        property bool __ignore: false

        onPressedChanged: {
            if (!pressed && !__ignore) {
                self.clicked()
            }
            __ignore = false;
        }

        onFocusChanged: {
            __ignore = true;
            pressed = false;
        }

        StandardAsset {
            id: background
            anchors.fill: parent
            anchors.topMargin: 5
            anchors.leftMargin: 5
            anchors.rightMargin: 5
            anchors.bottomMargin: -10

            background: self.enabled
                 ? (self.current ? "CC0000" : "333333")
                 : "666666"
            degrade: self.enabled
            reflet: true
            border: (self.enabled && self.hovered) ? "FF0000" : ""
        }

        Text {
            text: self.text
            font.bold: true
            font.pixelSize: self.height / 2
            smooth: true
            color: "white"
            anchors.centerIn: parent
        }

        MouseArea {
            id: mouse
            anchors.fill: parent
            enabled: self.enabled
            hoverEnabled: self.enabled
            onPressed: self.pressed = true;
            onReleased: self.pressed = false;
        }

        Keys.onPressed: {
            if (!self.enabled)
                return;

            if (event.key == Qt.Key_Return) {
                event.accepted = true;
                self.pressed = true;
                return;
            }
        }

        Keys.onReleased: {
            if (!self.enabled)
                return;

            if (event.key == Qt.Key_Return) {
                event.accepted = true;
                self.pressed = false;
                return;
            }
        }
    }

    orientation: ListView.Horizontal

    implicitWidth: 500
    implicitHeight: 40

    preferredHighlightBegin: width * .33
    preferredHighlightEnd: width * .66

    highlightRangeMode: ListView.ApplyRange
    highlightMoveDuration: 100
}
