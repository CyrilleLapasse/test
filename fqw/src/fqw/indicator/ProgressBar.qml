import QtQuick 1.1
import fqw.internal 1.0

Item {
    id: widget

    /*** Public interface */

    property int value: 0;
    property int minimumValue: 0;
    property int maximumValue: 100;

    property int preloadValue: 0;
    property bool smooth: true;
    property bool border: false;

    property int margin: 6;

    implicitWidth: 300
    implicitHeight: 40

    // Jump to new value without animation
    // reset(value)

    /*** Private */

    function reset(value) {
        main.smooth = false;
        widget.value = value;
        main.smooth = true;
    }

    function mkRatio(x)
    {
        return (x - minimumValue + 0.) / (maximumValue - minimumValue);
    }

    StandardAsset {
        anchors.margins: widget.margin;
        anchors.fill: parent;
        background: "666666";
    }

    ClippedBar {
        anchors.margins: widget.margin;
        anchors.fill: parent;
        color: "009900";
        ratio: mkRatio(preloadValue);
    }

    ClippedBar {
        id: main;

        anchors.margins: widget.margin;
        anchors.fill: parent;
        color: "CC0000";
        ratio: mkRatio(value);
        property bool smooth: true;

        Behavior on ratio {
            enabled: widget.smooth && main.smooth;
            NumberAnimation { duration: 200; }
        }
    }

    StandardAsset {
        visible: widget.border;
        anchors.margins: widget.margin;
        anchors.fill: parent;
        border: "FFFFFF";
    }
}
