import QtQuick 1.1
import fqw.indicator 1.0
import fqw.control 1.0
import fqw.controller 1.0
import fqw.util 1.0
import fqw.menu 1.0

Rectangle {
    id: page

    implicitWidth: 800
    implicitHeight: 480

    FocusShower {
        id: main
        anchors.fill: parent
    }

    View {
        id: menu
        returnFocusTo: main
        root: menu0

        Menu {
            id: menu0
            title: "Menu0"
        
            Section { text: "Subcategories" }
            Submenu { target: menu1 }
            Submenu { target: menu2 }

            Section { text: "Actions" }
            Action { text: "Unavailable"; enabled: false; }
            Action { text: "Close"; onClicked: close(); }
        }

        Menu {
            id: menu2
            title: "Menu2"

            Item {
                height: 80;
                Loading {
                    anchors.fill: parent;
                    anchors.margins: 5;
                }
            }

            Action { text: "Close"; onClicked: close(); }
            Action { text: "Pop"; onClicked: pop(); }
        }

        Menu {
            id: menu1
            title: "Menu1"

            Section { text: "Actions" }
            Action { text: "Close"; onClicked: close(); }
            Action { text: "Pop"; onClicked: pop(); }

            Section { text: "Generated entries" }
            Repeater {
                delegate: CheckBox {
                    text: "Entry " + index;
                    exclusiveGroup: eg;
                    value: index;
                }
                model: 50
            }
        }
    }

    CheckableGroup {
        id: eg
        onValueChanged: console.log("menu generated entry is now", value)
    }

    Keys.forwardTo: menu
}
