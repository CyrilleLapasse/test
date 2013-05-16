import QtQuick 1.1
import fqw.indicator 1.0
import fqw.controller 1.0
import "View.js" as Priv

FocusScope {
    id: menu
    objectName: "fqw.menu.View";

    property Item returnFocusTo;
    property Item root;

    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    width: 300

    anchors.leftMargin: (width + 100) * delta
    property real delta: activeFocus ? 0 : -1
    Behavior on delta { NumberAnimation { duration: 300; easing.type: Easing.InOutBack } }

    onDeltaChanged: {
        if (delta == -1)
            Priv.rewind();
    }

    function close()
    {
        returnFocusTo.focus = true;
    }

    function push(id)
    {
        Priv.push(id);
    }

    function pop()
    {
        return Priv.pop();
    }

    BorderImage {
        source: "background.png"
        anchors.leftMargin: -150
        anchors.rightMargin: -30
        anchors.fill: parent

        border { left: 31; right: 31; top: 44; bottom: 0 }
    }

    Text {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        font.pixelSize: 35
        color: "black"
        elide: Text.ElideRight
        text: tm.currentItem ? tm.currentItem.title : ""
    }

    Component.onCompleted: Priv.init()
    onRootChanged: Priv.resetRoot()

    TransitionManager {
        id: tm
        anchors.fill: parent
        anchors.topMargin: 40
        focus: true
        clip: true

        onDidHideItem: {
            if (previousItem)
                previousItem.menu = null;
            //console.log("onDidHideItem", previousUid, previousItem)
        }

        onDidShowItem: {
            if (currentItem)
                currentItem.menu = menu;
            //console.log("onDidShowItem", currentUid, currentItem)
        }

        onWillSwitchItems: {
            //console.log("onWillSwitchItems",
            //            currentUid, currentItem,
            //            nextUid, nextItem)
        }
    }

    Keys.onPressed: {
        switch (event.key) {
        case Qt.Key_Left:
            if (activeFocus) {
                event.accepted = true;
                Priv.pop();
            }

        case Qt.Key_Escape:
        case Qt.Key_Back: {
            if (activeFocus) {
                event.accepted = true;
                if (!Priv.pop())
                    menu.close();
            }
            break;
        }

        case Qt.Key_Menu:
        case Qt.Key_F2: {
            if (activeFocus) {
                event.accepted = true;
                close();
            } else if (!activeFocus && returnFocusTo) {
                event.accepted = true;
                open();
            }
        }
        }
    }

    function open(returnTo)
    {
        if (!returnTo && !returnFocusTo) {
            console.log("This will loose focus, please set a way back");
            return;
        }
        if (returnTo)
            returnFocusTo = returnTo;

        menu.focus = true;
    }
}
