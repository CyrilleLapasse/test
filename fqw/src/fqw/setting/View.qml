import QtQuick 1.1
import fqw.page 1.0
import fqw.util 1.0
import fqw.indicator 1.0

Item {
    id: view

    /** Public API */
    // Info panel height
    property alias infoPanelHeight: info.height
    property alias initialPage: pageStack.initialPage;
    property alias baseUrl: pageStack.baseUrl

    /** Private */

    property alias depth: pageStack.depth

    onDepthChanged: {
        if (!depth)
            pop();
        else
            pageStack.focus = true;
    }

    function push(x,y) { pageStack.push(x,y); }

    Background {
        background: "player";
        fillMode: Image.PreserveAspectCrop
    }

    Stack {
        id: pageStack
        focus: true;

        anchors.top: title.bottom
        anchors.left: title.left
        anchors.right: title.right
        anchors.bottom: info.top
        anchors.margins: 10

        KeyNavigation.up: title;
    }

    Breadcrumb {
        id: title;

        z: 15

        stack: pageStack

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        KeyNavigation.down: pageStack;
    }

    Rectangle {
        id: info

        visible: requested && (pageStack.currentPage ? pageStack.currentPage.showInfo : true);
        property bool requested: true

        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        color: "#cc000000"
    
        height: visible ? 180 : 0;

        InfoPanel {
            anchors.fill: parent

            movingRight: pageStack.currentPage ? pageStack.currentPage.movingUp : true;
            text: pageStack.currentPage ? pageStack.currentPage.info : "";
        }
    }

    Keys.onPressed: {
        if (event.key == Qt.Key_Help)
            info.requested = !info.requested;
    }
}


