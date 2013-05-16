import QtQuick 1.1
import fqw.indicator 1.0
import fqw.menu 1.0 as Menu

Menu.Action {
    property Item target;
    text: target ? target.title : ""
    onClicked: push(target)

    PlayerStatus {
        status: "play";
        anchors.right: parent.right;
        anchors.rightMargin: 5;
        anchors.verticalCenter: parent.verticalCenter;
        height: parent.height / 2;
    }

    Keys.onPressed: {
        switch (event.key) {
        case Qt.Key_Right: {
            clicked();
            event.accepted = true;
        }
        }
    }
}
