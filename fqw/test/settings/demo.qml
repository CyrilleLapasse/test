import QtQuick 1.1
import fqw.setting 1.0
import fqw.control 1.0

Page {
    title: "Settings demo"

    Section {
        text: "Widgets"
    }

    LinkButton {
        text: "Link Button"
        info: "Pushes another settings page"
    }

    Item {
        text: "Combo box"
        info: "Shows the user multiple values for a given metric"

        Combo {
            items: ListModel {
                ListElement { label: "Sometimes"; value: "a" }
                ListElement { label: "Always"; value: "b" }
                ListElement { label: "Maybe"; value: "c" }
            }
        }
    }

    Item {
        text: "Switch"
        info: "Basic boolean value edition"

        Switch {
        }
    }

    Item {
        text: "Text input"
        info: "General-purpose text input"

        TextInput {
            text: "some text"
        }
    }

    Spacer {
    }

    Section {
        text: "Another section"
    }

    Item {
        text: "Another switch"
        info: "Just to show off"

        Switch {
        }
    }
}
