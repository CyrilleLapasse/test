import QtQuick 1.1
import fqw.controller 1.0
import fqw.util 1.0
import fqw.internal 1.0

FocusScope {
    clip: true

    property string title: "Menu"

    default property alias elements: scrollable.elements;
    property alias currentIndex: scrollable.currentIndex;
    property Item menu

    /** Public API */

    function close()
    {
        menu.close();
    }

    ScrollableColumn {
        id: scrollable
        focus: true
        anchors.fill: parent
        highlight: StandardAsset {
            anchors {
                fill: parent
                leftMargin: -20
                rightMargin: 2
                topMargin: 2
                bottomMargin: 2
            }
            background: "CC0000"
            reflet: true
        }

        function isUsable(item)
        {
            if (item.objectName != "fqw.menu.Item")
                return false;
            if (!item.visible)
                return false;
            if (item.enabled !== undefined && !item.enabled)
                return false;
            return true;
        }
    }
}
