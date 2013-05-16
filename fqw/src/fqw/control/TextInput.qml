import QtQuick 1.1
import fqw.util 1.0
import fqw.internal 1.0

FocusToggler {
    id: widget

    implicitHeight: 40
    implicitWidth: 300

    /*** Signals */
    signal accepted();

    /*** Appearance */
    /* Text shown when input line is empty, shaded. */
    property string placeholderText: "Appuyez sur 'OK'"
    /* Usual echo modes, TextInput.Password, TextInput.PasswordEchoOnEdit */
    property alias echoMode: textInput.echoMode;

    property bool errorHighlight: false;

    /*** Styling */
    property alias validator: textInput.validator
    property alias color: textInput.color
    property alias font: textInput.font
    property alias selectionColor: textInput.selectionColor
    property alias horizontalAlignment: textInput.horizontalAlignment

    /*** Data */
    /* Actual entered text, may not be validated yet. */
    property string text
    /* Maximal length of text */
    property alias maximumLength: textInput.maximumLength
    /* Cursor position in the line. R/W */
    property alias cursorPosition: textInput.cursorPosition;

    /*** Behavior */
    /* Hint for virtual keyboard
       Use Qt.ImhDigitsOnly, Qt.ImhUrlCharactersOnly, Qt.ImhEmailCharactersOnly */
    property alias inputMethodHints: textInput.inputMethodHints

    property string displayText

    // Internal

    control: textInput;

    KeyNavigation.priority: KeyNavigation.BeforeItem;

    StandardAsset {
        border: widget.enabled ? (widget.activeFocus ? "FF0000" : "FFFFFF") : "";
        blur: widget.errorHighlight
        blurColor: widget.enabled ? "CC0000" : ""
        anchors.fill: parent
        anchors.margins: 6;
        background: widget.enabled ? "FFFFFF" : "666666"
    }

    TextInput {
        id: textInput

        smooth: true;
        activeFocusOnPress: widget.enabled;
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 2
        font.pixelSize: 20
        color: "black"
        anchors.fill: parent
        anchors.leftMargin: 16
        anchors.rightMargin: 16
        anchors.topMargin: 8
        anchors.bottomMargin: 8
        clip: true
        readOnly: !widget.enabled

        onActiveFocusChanged: {
            cursorVisible = textInput.activeFocus;
        }

        KeyNavigation.priority: KeyNavigation.BeforeItem;
        KeyNavigation.up: widget.KeyNavigation.up
        KeyNavigation.down: widget.KeyNavigation.down

        onAccepted: {
            widget.text = text;
            widget.leaveEditing();
            widget.accepted();
        }

        Keys.onPressed: {
            switch (event.key) {
            case Qt.Key_Delete: {
                var m = Qt.ControlModifier | Qt.ShiftModifier;
                if ((event.modifiers & m) == m) {
                    event.accepted = true;
                    text = "";
                }
                break;
            }

            case Qt.Key_Escape:
            case Qt.Key_Back: {
                event.accepted = true

                if (text == "") {
                    event.accepted = widget.leaveEditing()
                    if (event.accepted)
                        textInput.text = widget.text;
                } else {
                    text = ""
                }
                break;
            }
            }
        }
    }

    onTextChanged: {
        if (textInput.text != text)
            textInput.text = text;
        switch (echoMode) {
        case TextInput.Normal: {
            displayText = text;
            break;
        }
        case TextInput.NoEcho: {
            displayText = "";
            break;
        }
        case TextInput.PasswordEchoOnEdit:
        case TextInput.Password: {
            displayText = "************".substr(0, text.length);
            break;
        }
        }
    }

    Text {
        clip: true
        anchors.fill: textInput
        anchors.topMargin: 2
        visible: textInput.text == "" && widget.enabled
        text: placeholderText
        font.pixelSize: 20
        color: "grey"
        style: Text.Raised;
        styleColor: "white"
    }
}
