import QtQuick 1.1
import fqw.control 1.0
import fqw.controller 1.0
import fqw.indicator 1.0
import fqw.util 1.0

Item {
    id: page
    implicitWidth: 640
    implicitHeight: 480

    Background {
        background: "text"
        logo: "freebox"
    }

    Flow {
        id: flow
        anchors.fill: parent
    
        KeyFocusController {
            id: nav
            root: flow

            function isItemFocusable(i)
            {
                return i.enabled;
            }
        }

        Keys.onPressed: nav.pressed(event)

        Text {
            text: page.title
        }

        Switch {
            id: iSwitch
            checked: true
            focus: true
        }

        Button {
            enabled: iSwitch.checked
            id: ok
            text: "OK"
            onClicked: textInput.text = "OK"
        }

        Button {
            enabled: iSwitch.checked
            id: cancel
            text: "Cancel"
            onClicked: textInput.text = "Cancel"
        }

        Combo {
            items: ListModel {
                ListElement { label: "HDMI"; value: "AudioOutportHdmi" }
                ListElement { label: "SPDIF"; value: "AudioOutportSpdif" }
                ListElement { label: "SPDIF2"; value: "AudioOutportSpdif2" }
                ListElement { label: "SPDIF3"; value: "AudioOutportSpdif3" }
                ListElement { label: "SPDIF4"; value: "AudioOutportSpdif4" }
                ListElement { label: "SPDIF5"; value: "AudioOutportSpdif5" }
                ListElement { label: "SPDIF6"; value: "AudioOutportSpdif6" }
                ListElement { label: "SPDIF7"; value: "AudioOutportSpdif7" }
                ListElement { label: "SPDIF8"; value: "AudioOutportSpdif8" }
                ListElement { label: "Analogique"; value: "AudioOutportAnalog" }
            }
            enabled: iSwitch.checked
            id: combo
            onSelected: console.log("selected", index, value);
        }

        CheckBox {
            id: readOnlySwitch
            text: "Read only"
            checked: false
        }

        TextArea {
            id: textArea
            readOnly: readOnlySwitch.checked
            enabled: iSwitch.checked
            placeholderText: "Tapez un roman"
            height: 200
            text: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum"

            textFormat: TextEdit.RichText
        }
    
        Switch {
            id: switchWidget
            enabled: iSwitch.checked
        }

        Loading {
            visible: switchWidget.checked
            height: 40
        }
    
        Slider {
            id: sliderWidget
            enabled: iSwitch.checked
            value: 30
            minimumValue: 0
            maximumValue: 100
        }

        Slider {
            id: sliderWidget2
            enabled: iSwitch.checked
            value: 50
            minimumValue: 0
            maximumValue: 100
            autoFocus: true
        }
    
        TextInput {
            id: textInput
            enabled: iSwitch.checked
            placeholderText: "Username"
            text: "john"
            autoFocus: true
            onAccepted: console.log("Entered '"+text+"'");
        }

        TextInput {
            id: passInput
            enabled: iSwitch.checked
            placeholderText: "Password"
            text: "blabla"
            echoMode: TextInput.PasswordEchoOnEdit
            onAccepted: console.log("Entered '"+text+"'");
        }

        TextInput {
            id: numericInput
            enabled: iSwitch.checked
            placeholderText: "Say 1234"
            text: ""
            inputMethodHints: Qt.ImhDigitsOnly
            onAccepted: {
                console.log("Entered '"+text+"'");
                errorHighlight = text != "1234";
            }
            validator: RegExpValidator { regExp: /^\d{4}$/ }
        }

        Button {
            id: play
            text: ""
            PlayerStatus { status: "play"; anchors.centerIn: parent; height: parent.height / 3 }
            onClicked: timeline.status = "play"
            width: height
        }

        Button {
            id: pause
            text: ""
            PlayerStatus { status: "pause"; anchors.centerIn: parent; height: parent.height / 3 }
            onClicked: timeline.status = "pause"
            width: height
        }

        Button {
            id: ff
            text: ""
            PlayerStatus { status: "ff"; anchors.centerIn: parent; height: parent.height / 3 }
            onClicked: timeline.status = "ff"
            width: height
        }

        Button {
            id: rew
            text: ""
            PlayerStatus { status: "rew"; anchors.centerIn: parent; height: parent.height / 3 }
            onClicked: timeline.status = "rew"
            width: height
        }

        CheckableGroup {
            id: group
            onValueChanged: console.log("Checked value is", value);
        }

        CheckBox {
            id: radio_a
            enabled: check_a.checked && iSwitch.checked

            exclusiveGroup: group
            text: "a"
            value: "a"
        }

        CheckBox {
            id: radio_b
            enabled: check_b.checked && iSwitch.checked

            exclusiveGroup: group
            text: "b"
            value: "b"
        }

        CheckBox {
            id: radio_c
            enabled: check_c.checked && iSwitch.checked

            exclusiveGroup: group
            text: "c"
            value: "c"
        }

        CheckBox {
            id: radio_d
            enabled: check_d.checked && iSwitch.checked

            exclusiveGroup: group
            text: "d"
            value: "d"
        }

        CheckBox {
            id: radio_e
            enabled: check_e.checked && iSwitch.checked

            exclusiveGroup: group
            text: "e"
            value: "e"
        }

        CheckBox {
            enabled: iSwitch.checked
            id: check_a
            checked: true

            text: "a"
            value: "a"
        }

        CheckBox {
            enabled: iSwitch.checked
            id: check_b
            checked: true

            text: "b"
            value: "b"
        }

        CheckBox {
            enabled: iSwitch.checked
            id: check_c
            checked: true

            text: "c"
            value: "c"
        }

        CheckBox {
            enabled: iSwitch.checked
            id: check_d
            checked: true

            text: "d"
            value: "d"
        }

        CheckBox {
            enabled: iSwitch.checked
            id: check_e
            checked: false

            text: "e"
            value: "e"
        }

        ProgressBar {
            anchors.margins: 2
            minimumValue: 0
            maximumValue: 100
            value: sliderWidget.value
            preloadValue: sliderWidget2.value
        }

        TimeLine {
            id: timeline
            anchors.margins: 2
            minimumValue: 0
            maximumValue: 100
            value: sliderWidget.value
            preloadValue: sliderWidget2.value
            endTimeLabel: "[" + maximumValue + "]"
            currentTimeLabel: "[" + value + "]"
            nameLabel: textInput.text
        }
    }
}

