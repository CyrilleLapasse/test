import QtQuick 1.1
import "keyfocuscontroller.js" as Script

QtObject {
    id: self
    property Item root

    function pressed(event)
    {
        return Script.pressed(event);
    }

    function isItemFocusable(item)
    {
        return true;
    }
}
