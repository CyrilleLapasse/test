import QtQuick 1.1
import fqw.control 1.0
import fqw.controller 1.0
import fqw.util 1.0

Rectangle {
    id: page
    implicitWidth: 800
    implicitHeight: 200

    color: "black"

    CheckableGroup {
        id: group
        onValueChanged: console.log("Checked value is", value);
    }
    
    KeyFocusController {
        id: nav
        root: page

        function isItemFocusable(i)
        {
            return i.enabled;
        }
    }

    Keys.onPressed: nav.pressed(event)
        
    CheckBox {
        id: radio_a
        enabled: check_a.checked

        exclusiveGroup: group
        text: "a"
        value: "a"
    }

    CheckBox {
        id: radio_b
        enabled: check_b.checked

        exclusiveGroup: group
        text: "b"
        value: "b"

        anchors.left: radio_a.right
    }

    CheckBox {
        id: radio_c
        enabled: check_c.checked

        exclusiveGroup: group
        text: "c"
        value: "c"

        anchors.left: radio_b.right
    }

    CheckBox {
        id: radio_d
        enabled: check_d.checked

        exclusiveGroup: group
        text: "d"
        value: "d"

        anchors.left: radio_c.right
    }

    CheckBox {
        id: radio_e
        enabled: check_e.checked

        exclusiveGroup: group
        text: "e"
        value: "e"

        anchors.left: radio_d.right
    }

    CheckBox {
        id: check_a
        checked: true

        text: "a"
        value: "a"

        anchors.top: radio_a.bottom
        anchors.left: radio_a.left
    }

    CheckBox {
        id: check_b
        checked: true

        text: "b"
        value: "b"

        anchors.top: radio_b.bottom
        anchors.left: radio_b.left
    }

    CheckBox {
        id: check_c
        checked: true

        text: "c"
        value: "c"

        anchors.top: radio_c.bottom
        anchors.left: radio_c.left
    }

    CheckBox {
        id: check_d
        checked: true

        text: "d"
        value: "d"

        anchors.top: radio_d.bottom
        anchors.left: radio_d.left
    }

    CheckBox {
        id: check_e
        checked: false

        text: "e"
        value: "e"

        anchors.top: radio_e.bottom
        anchors.left: radio_e.left
    }
}
