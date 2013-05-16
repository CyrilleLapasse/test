import QtQuick 1.1
import fqw.page 1.0
import fqw.controller 1.0
import fqw.util 1.0
import fqw.internal 1.0

Page {
    id: page

    persistentProperties: ["currentIndex"]
    property alias currentIndex: scrollable.currentIndex;

    property bool showInfo: true
    property string info;
    property alias movingUp: scrollable.movingUp;

    default property alias elements: scrollable.elements;

    ScrollableColumn {
        id: scrollable
        focus: true

        anchors.fill: parent

        highlightMoveDuration: 50
        highlight: StandardAsset {
            anchors {
                fill: parent
                margins: 2
            }
            background: "CC0000"
            reflet: true
        }
    
        function isUsable(item)
        {
            if (item.objectName != "fqw.setting.Item")
                return false;
            if (!item.visible)
                return false;
            if (item.enabled !== undefined && !item.enabled)
                return false;
            return true;
        }

        onCurrentIndexChanged: page.info = currentIndex < 0 ? "" : (currentItem ? currentItem.info : "");
    }
}


