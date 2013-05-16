import QtQuick 1.1
import fqw.page 1.0
import fqw.control 1.0

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

        onClicked: stack.push("page1.qml", {title: "Depth "+stack.depth});
    }

    Button {
        id: popButton

        anchors.bottom: pushButton.top
        anchors.right: parent.right

        text: "Pop"

        onClicked: stack.pop();
    }

    Stack {
        id: stack
        z: -1
        focus: true

        anchors.fill: parent

        baseUrl: "../../../test/pages/"
        initialPage: "page1.qml"
    }
}
