import QtQuick 1.1
import fqw.controller 1.0
import fqw.control 1.0
import fqw.util 1.0

Item {
    width: 440;
    height: 400;

    TransitionManager {
        id: tm;

        x: 100;
        y: 50;
        width: 100;
        height: 50;

        duration: 700
    }

    Column {
        x: 300;
        y: 0;
        height: parent.height;
        width: 140;

        CheckBox { exclusiveGroup: transitionName; text: "->"; value: "slideRight" }
        CheckBox { exclusiveGroup: transitionName; text: "<-"; value: "slideLeft" }
        CheckBox { exclusiveGroup: transitionName; text: "Appear"; value: "appear" }
        CheckBox { exclusiveGroup: transitionName; text: "Fade"; value: "fade" }
        CheckBox { exclusiveGroup: transitionName; text: "In"; value: "scaleDown" }
        CheckBox { exclusiveGroup: transitionName; text: "Out"; value: "scaleUp" }

        Button { text: "blue"; onClicked: tm.switchToItem(blue, transitionName.value) }
        Button { text: "red"; onClicked: tm.switchToItem(red, transitionName.value) }
        Button { text: "green"; onClicked: tm.switchToItem(green, transitionName.value) }
    }

    Item {
        visible: false;

        Rectangle { id: blue; color: "blue" }
        Rectangle { id: red; color: "red" }
        Rectangle { id: green; color: "green" }
    }

    CheckableGroup {
        id: transitionName
    }
}

