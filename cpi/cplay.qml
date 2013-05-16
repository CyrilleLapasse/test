import QtQuick 1.1
import fqw.page 1.0
import fqw.indicator 1.0
import fqw.control 1.0
import fqw.controller 1.0
import fqw.util 1.0
import "debug.js" as Debug
import "cplay.js" as Cplay

FocusScope {
    id: self
    width: 1280
    height: 720
    focus: true

   Button {
        id: pushButton
        opacity: 0
        anchors.bottom: parent.bottom
        anchors.right: parent.right

        text: "Push"

        onClicked: stack.push("page1.qml", {
            title:  Cplay.getMenu(stack.depth),
            ratio: .5
        });
    }

    Button {
        id: popButton
        opacity: 0
        anchors.bottom: pushButton.top
        anchors.right: parent.right

        text: "Pop"

        onClicked: stack.pop();
    }

    Button {
        id: replaceButton
        opacity: 0
        anchors.bottom: popButton.top
        anchors.right: parent.right

        text: "Replace"

        onClicked: stack.replace("page1.qml", {
            title: "Depth " + (stack.depth - 1),
            ratio: .5
        });
    }

    Button {
        id: debugButton
        opacity: 0
        anchors.bottom: replaceButton.top
        anchors.right: parent.right

        text: "Debug"

        onClicked: Debug.treeDump(self);
    }

    CheckBox {
        id: cprButton
        opacity: 0
        anchors.bottom: debugButton.top
        anchors.right: parent.right

        text: "Pop root"
    }

    CheckBox {
        id: slowButton
        opacity: 0
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
    Keys.onUpPressed: Debug.treeDump(self)
}
