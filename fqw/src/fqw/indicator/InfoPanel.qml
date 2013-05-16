import QtQuick 1.1
import fqw.util 1.0
    
Item {
    id: widget;
    property string text: "";
    property bool movingRight: true;

    Background {
        background: "infopanel"
        logo: "info"
        logoRatio: .8
        anchors.topMargin: -16

        Item {
            y: 18;
            id: mover
            width: parent.width;
            height: parent.height - 18;
    
            Text {
                id: currentText;
                anchors.fill: parent;
                anchors.margins: 8;
                color: "white";
                text: "";
                font.pixelSize: 20;
                wrapMode: Text.WordWrap;
            }
        }
    }

    SequentialAnimation {
        id: replaceTextRight;
        PropertyAction    { target: mover; property: "x"; value: -widget.width; }
        ScriptAction      { script: currentText.text = widget.text; }
        PropertyAnimation { target: mover; property: "x"; to: 0; duration: 200; easing.type: Easing.OutBack }
    }

    SequentialAnimation {
        id: replaceTextLeft;
        PropertyAction    { target: mover; property: "x"; value: widget.width; }
        ScriptAction      { script: currentText.text = widget.text; }
        PropertyAnimation { target: mover; property: "x"; to: 0; duration: 200; easing.type: Easing.OutBack }
    }

    onTextChanged: {
        replaceTextLeft.stop();
        replaceTextRight.stop();
        if (movingRight)
            replaceTextLeft.start();
        else
            replaceTextRight.start();
    }
}
