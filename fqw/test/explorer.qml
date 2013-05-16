import QtQuick 1.1
import fqw.page 1.0
import fqw.control 1.0
import "debug.js" as Debug

FocusScope {
    id: self
    width: 800
    height: 600
    focus: true

    Button {
        id: pushButton

        anchors.bottom: parent.bottom
        anchors.right: parent.right

        text: "Push"

        onClicked: stack.push("page2.qml", {
            title: "Depth "+stack.depth,
            ratio: .3 + (stack.depth % 5) / 10.
        });
    }

    Button {
        id: popButton

        anchors.bottom: pushButton.top
        anchors.right: parent.right

        text: "Pop"

        onClicked: stack.pop();
    }

    Button {
        id: replaceButton

        anchors.bottom: popButton.top
        anchors.right: parent.right

        text: "Replace"

        onClicked: stack.replace("page2.qml", {
            title: "Depth " + (stack.depth - 1),
            ratio: .3 + ((stack.depth - 1) % 5) / 10.
        });
    }

    Button {
        id: debugButton

        anchors.bottom: replaceButton.top
        anchors.right: parent.right

        text: "Debug"

        onClicked: Debug.treeDump(self);
    }

    CheckBox {
        id: cprButton

        anchors.bottom: debugButton.top
        anchors.right: parent.right

        text: "Pop root"
    }

    CheckBox {
        id: slowButton

        anchors.bottom: cprButton.top
        anchors.right: parent.right

        text: "Slow"
    }

    Breadcrumb {
        id: breadcrumb
        z: -1

        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }
        stack: stack

        KeyNavigation.down: stack
    }

    Explorer {
        id: stack
        z: -1
        focus: true

        anchors {
            left: parent.left
            right: parent.right
            top: breadcrumb.bottom
            bottom: parent.bottom
        }

        duration: slowButton.checked ? 1500 : 150

        baseUrl: "../../../test/pages/"
        initialPage: "page1.qml"

        canPopRoot: cprButton.checked

        KeyNavigation.up: breadcrumb
    }

    Keys.onLeftPressed: popButton.clicked()
    Keys.onRightPressed: pushButton.clicked()
    Keys.onUpPressed: Debug.treeDump(self)
}
