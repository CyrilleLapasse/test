import QtQuick 1.1
import fqw.internal 1.0

FocusScope {
    id: scope;
    objectName: "fqw.setting.Item"

    property alias text: labelItem.text;
    property string info: "";
    property bool enabled: true;
    height: visible ? 50 : 0;
    width: parent ? parent.width : 40;
    property int index: VisualItemModel.index;
    default property Item control;

    Behavior on height { NumberAnimation {} }

    children: [
        StandardAsset {
            id: back;
            background: "333333";
            anchors.fill: container;
            opacity: container.editing ? 1 : .4
        },
        Item {
            id: container;
    
            opacity: scope.enabled ? 1 : .3
    
            anchors.fill: parent;
            anchors.margins: 2
            property bool editing: false;
    
            Text {
                id: labelItem;
        
                anchors {
                    top: container.top
                    left: container.left
                    bottom: container.bottom
                    leftMargin: 10
                }
        
                elide: Text.ElideRight;
                font.pixelSize: container.height / 1.9;
                color: "white";
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
            }
    
            Text {
                id: placeholder;
                opacity: !scope.activeFocus && hasPlaceholder ? 1 : 0;
                onOpacityChanged: control.opacity = 1 - opacity;
    
                anchors {
                    top: container.top
                    right: container.right
                    bottom: container.bottom
                    rightMargin: 10
                }
    
                elide: Text.ElideLeft;
                font.pixelSize: container.height / 2;
                color: "white";
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
            }
        }
    ]

    property bool hasPlaceholder: false;

    function displayTextChanged() {
        try {
            placeholder.text = control.displayText;
            hasPlaceholder = true;
        } catch (e) {
            hasPlaceholder = false;
        }
    }

    function editingChanged() {
        container.editing = control.editing;
    }

    onActiveFocusChanged: updateInteractive(activeFocus);

    function updateInteractive(enabledControl) {
        if (control === null)
            return;

        control.focus = true;
        control.enabled = enabledControl;
    }

    function updateTextWidth () {
        labelItem.width = scope.width - control.width;
    }

    onWidthChanged: updateTextWidth();

    Component.onCompleted: {
        control.parent = container;
        control.anchors.top = container.top;
        control.anchors.bottom = container.bottom;
        control.anchors.right = container.right;
        control.anchors.margins = 1;
        labelItem.anchors.right = control.left;
        control.widthChanged.connect(scope, updateTextWidth)
        control.focus = true;
        updateInteractive(focus);
        if (control.editingChanged) {
            control.editingChanged.connect(scope, editingChanged);
            scope.editingChanged();
        }
        if (control.displayTextChanged) {
            control.displayTextChanged.connect(scope, displayTextChanged);
            scope.displayTextChanged();
        }
    }

    Component.onDestruction: {
        control.widthChanged.disconnect(scope, updateTextWidth)
        if (control.editingChanged)
            control.editingChanged.disconnect(scope, editingChanged)
        if (control.displayTextChanged)
            control.displayTextChanged.disconnect(scope, displayTextChanged)
    }
}
