import QtQuick 1.1

Item {
    id: widget

    property bool checked: false
    property variant value: null
    property QtObject exclusiveGroup: null

    function toggle() {
        checked = !checked;
    }

    onExclusiveGroupChanged: {
        if (exclusiveGroup)
            exclusiveGroup.__add(widget);
    }

    Component.onDestruction: exclusiveGroup = null;
}
