import QtQuick 1.1
import fqw.page 1.0
import fqw.control 1.0
import fqw.controller 1.0
import fqw.indicator 1.0
import fqw.util 1.0

import "cplay.js" as Cplay

FocusScope {

    id: root

    width: 1280
    height: 720
    focus: true

    KeyFocusController {
        id: nav
        root: root
    }

    FocusShower {
        id: item
        objectName: "a"
        text: name
        x: 10
        y: 10
        width: 600
        height: 40
    }

    FocusShower {
        objectName: "b"
        x: a.x+10
        y: 0
        width: 600
        height: 40
    }

    FocusShower {
        objectName: "c"
        x: 10
        y: 40
        width: 600
        height: 40
    }

    FocusShower {
        objectName: "e"
        x: 10
        y: 160
        width: 600
        height: 40
    }

    FocusShower {
        objectName: "d"
        x: 10
        y: 80
        width: 600
        height: 40

        focus: true
    }

    Keys.onPressed: nav.pressed(event)
}
