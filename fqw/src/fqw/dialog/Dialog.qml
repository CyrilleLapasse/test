import QtQuick 1.1
import fqw.control 1.0

FocusScope {
    id: self

    property alias title: header.text
    property variant buttons: ["OK"]
    property bool hasControls: false
    property bool cancellable: !modal
    property bool modal: false

    function show()
    {
        self.enabled = true;
        self.focus = true;
    }

    function hide(focusItem)
    {
        self.enabled = false;
        if (focusItem)
            focusItem.focus = true;
    }

    signal selected(int button)


    onActiveFocusChanged: {
        if (!activeFocus && enabled)
            selected(-2)
    }

    anchors.centerIn: parent
    width: Math.min(Math.max(buttonRow.width, bodyColumn.childrenRect.width) + 20, parent.width - 100)
    height: Math.min(header.height + bodyColumn.childrenRect.height + buttonRow.height + 30, parent.height - 100)

    default property alias contentItems: bodyColumn.data

    enabled: false

    opacity: enabled && activeFocus ? 1 : 0

    Behavior on opacity { NumberAnimation { } }

    function buttonPressed(index)
    {
        self.selected(index);
    }

    children: [
        Rectangle {
            visible: modal
            anchors.centerIn: parent
            width: parent.parent ? parent.parent.width * 2 : parent.width
            height: parent.parent ? parent.parent.height * 2 : parent.height
            color: "#80000000"

            MouseArea {
                anchors.fill: parent
                enabled: true
                hoverEnabled: true
            }
        },

        BorderImage {
            anchors.fill: parent
            anchors.margins: -23
    
            asynchronous: true;
            border { top: 65; bottom: 23; left: 23; right: 23 }
            source: "dialog_background.png"
        },
    
        Text {
            id: header
    
            width: parent.width
            height: 40
    
            text: "text"
    
            font {
                pixelSize: height * .8
                bold: true
            }
    
            clip: true
        },
    
        FocusScope {
            id: body

            clip: true
            anchors.fill: parent
            anchors.topMargin: header.height + 10
            anchors.bottomMargin: buttonRow.height + 10
            anchors.leftMargin: 10
            anchors.rightMargin: 10

            Column {
                id: bodyColumn
                spacing: 10

                anchors.centerIn: parent
            }
    
            KeyNavigation.down: buttonRow
        },

        FocusScope {
            id: buttonRow
            focus: true
    
            property int oneWidth: 180
            property int spacing: 20

            height: 40
            width: (oneWidth + spacing) * rep.count - spacing

            Repeater {
                id: rep
                model: self.buttons

                Button {
                    x: (buttonRow.oneWidth + buttonRow.spacing) * index
                    height: buttonRow.height
                    width: buttonRow.oneWidth

                    text: modelData
                    onClicked: self.buttonPressed(index)

                    Keys.onPressed: {
                        var item;

                        if (event.key == Qt.Key_Left) item = rep.itemAt(index - 1);
                        if (event.key == Qt.Key_Right) item = rep.itemAt(index + 1);

                        if (item) {
                            event.accepted = true;
                            item.focus = true;
                        }
                    }
                }
            }

            anchors.bottomMargin: 10
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
    
            KeyNavigation.up: hasControls ? body : null
        }
    ]
    
    Keys.onPressed: {
        switch (event.key) {
        case Qt.Key_Menu: {
            event.accepted = true;
            break;
        }
        case Qt.Key_Back:
        case Qt.Key_Escape: {
            if (cancellable) {
                self.selected(-1);
                event.accepted = true;
            }
            break;
        }
        }
    }

    onEnabledChanged: rep.itemAt(0).focus = true;
}
