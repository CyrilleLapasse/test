import QtQuick 1.1
import fqw.page 1.0
import fqw.control 1.0

FocusScope {
    id: self
    width: 800
    height: 600
    focus: true

    ListModel {
        id: pages

        ListElement {
            url: "page1.qml"
            title: "Tab 1"
        }
        ListElement {
            url: "page2.qml"
            title: "Tab 2"
        }
        ListElement {
            url: "page1.qml"
            title: "Tab 3"
        }
        ListElement {
            url: "page1.qml"
            title: "Tab 4"
        }
        ListElement {
            url: "page1.qml"
            title: "Tab 5"
        }
        ListElement {
            url: "page1.qml"
            title: "Tab 6"
        }
        ListElement {
            url: "page1.qml"
            title: "Tab 7"
        }
    }

    Tabs {
        id: stack
        z: -1
        focus: true

        model: pages

        anchors.fill: parent

        baseUrl: Qt.resolvedUrl("pages/")

        onCurrentIndexChanged: focus = true
    }
}
