import QtQuick 1.1
import fqw.controller 1.0
import fqw.indicator 1.0

FocusScope {
    id: root

    width: 400
    height: 400
    focus: true

    KeyFocusController {
        id: nav
        root: root
    }

    FocusShower {
        objectName: "a"
        x: 0
        y: 0
        width: 40
        height: 40
    }

    FocusShower {
        objectName: "b"
        x: 120
        y: 0
        width: 40
        height: 40
    }

    FocusShower {
        objectName: "c"
        x: 160
        y: 40
        width: 40
        height: 40
    }

    FocusShower {
        objectName: "e"
        x: 160
        y: 160
        width: 40
        height: 40
    }

    FocusShower {
        objectName: "d"
        x: 80
        y: 80
        width: 40
        height: 40

        focus: true
    }

    Keys.onPressed: nav.pressed(event)
}
