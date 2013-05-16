import QtQuick 1.1
import fqw.util 1.0

Rectangle {
    id: clock
    color: "#80000000"
    clip: true

    Time {
        id: timer
        format: "hhmm"
        onTimeChanged: {
            hd.item.next = time.charAt(0);
            hu.item.next = time.charAt(1);
            md.item.next = time.charAt(2);
            mu.item.next = time.charAt(3);
        }
    }

    Loader {
        id: hd
        sourceComponent: letter
        width: parent.width / 2
        height: parent.height / 2
        anchors.top: parent.top
        anchors.left: parent.left

        onLoaded: {
            item.outX = -1;
            item.inY = -1;
        }
    }

    Loader {
        id: hu
        sourceComponent: letter
        width: parent.width / 2
        height: parent.height / 2
        anchors.top: parent.top
        anchors.right: parent.right

        onLoaded: {
            item.outX = 1;
            item.inY = -1;
        }
    }

    Loader {
        id: md
        sourceComponent: letter
        width: parent.width / 2
        height: parent.height / 2
        anchors.bottom: parent.bottom
        anchors.left: parent.left

        onLoaded: {
            item.outX = -1;
            item.inY = 1;
        }
    }

    Loader {
        id: mu
        sourceComponent: letter
        width: parent.width / 2
        height: parent.height / 2
        anchors.bottom: parent.bottom
        anchors.right: parent.right

        onLoaded: {
            item.outX = 1;
            item.inY = 1;
        }
    }

    Component {
        id: letter

    
        Item {
            id: item
            anchors.fill: parent
    
            Text {
                id: t
    
                x: parent.offsetX * parent.width + parent.width / 10
                y: parent.offsetY * parent.height
                width: parent.width
                font.pixelSize: parent.height * 1.5
                font.family: "imagine font, courier"
                color: "#dd0"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: (item.outX > 0 && text == "1")
                    ? Text.AlignHCenter : Text.AlignRight
            }

            property string next: ""
            onNextChanged: {
                if (t.text)
                    animation.restart();
                else
                    t.text = next;
            }
    
            property real offsetX: 0
            property real offsetY: 0
    
            property real outX: 0
            property real outY: 0
    
            property real inX: 0
            property real inY: 0
    
            SequentialAnimation {
                id: animation
    
                ParallelAnimation {
                    PropertyAnimation {
                        target: item
                        property: "offsetX"
                        to: item.outX
                        duration: 1000
                    }
                    PropertyAnimation {
                        target: item
                        property: "offsetY"
                        to: item.outY
                        duration: 1000
                    }
                }
    
                ScriptAction {
                    script: {
                        item.offsetX = item.inX
                        item.offsetY = item.inY
                        t.text = item.next
                    }
                }
    
                ParallelAnimation {
                    PropertyAnimation {
                        target: item
                        property: "offsetX"
                        to: 0
                        duration: 1000
                    }
                    PropertyAnimation {
                        target: item
                        property: "offsetY"
                        to: 0
                        duration: 1000
                    }
                }
            }
        }
    }
}
