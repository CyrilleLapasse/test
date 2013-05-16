import QtQuick 1.1
import fqw.indicator 1.0
import fqw.dialog 1.0
import fqw.control 1.0

FocusScope {
    id: page
    focus: true

    implicitWidth: 640
    implicitHeight: 480

    Alert {
        id: dialog
        title: "Hello,"
        text: "World !"
        onSelected: {
            console.log("Selected", button);
            hide(main);
        }
    }

    Dialog {
        id: dialog2
        title: "Hello"

        modal: true
        buttons: ["OK", "Annuler"]

        hasControls: true

        FocusShower {
            width: 320
            height: 120
        }

        onSelected: {
            console.log("Selected", button);
            hide(main);
        }
    }

    FocusScope {
        id: main
        anchors.fill: parent
        z: -1
        focus: true

        Button {
            id: coucou
            focus: true
            text: "Coucou"
            onClicked: dialog.show()

            KeyNavigation.down: hello
        }

        Button {
            id: hello
            text: "Hello"
            onClicked: dialog2.show()

            KeyNavigation.up: coucou
            KeyNavigation.down: ti
            anchors.top: coucou.bottom
        }

        TextInput {
            id: ti
            KeyNavigation.up: hello
            anchors.top: hello.bottom
        }
    }
}
