import QtQuick 1.1
import fqw.control 1.0
import fqw.internal 1.0

FocusScope {
    id: self

    property QtObject model

    property alias baseUrl: stack.baseUrl
    property int currentIndex: -1
    property alias tip: stack.tip

    property variant commonProperties: []

    TabList {
        id: tabs

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        KeyNavigation.down: stack

        model: self.model

        onCurrentIndexChanged: {
            if (!activeFocus)
                self.currentIndex = currentIndex;
        }

        onSelected: {
            self.currentIndex = index;
        }

        onFocusChanged: {
            if (!focus)
                currentIndex = self.currentIndex;
        }
    }

    Stack {
        id: stack

        focus: true

        KeyNavigation.up: tabs

        anchors.top: tabs.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        animation: "slideLeft"

        property int currentIndex: -1
        property int targetIndex: -1

        onTipChanged: {
            stack.currentIndex = targetIndex;

            if (stack.currentIndex == self.currentIndex)
                tabs.currentIndex = stack.currentIndex;
            else
                switchTo(self.currentIndex);
        }

        function switchTo(index) {
            animation = index < stack.currentIndex ? "slideLeft" : "slideRight";

            var info = model.get(index);
            var args = {};
    
            for (var k in info) {
                if (k == "url")
                    continue;
                args[k] = info[k];
            }
    
            for (var k in commonProperties)
                args[k] = self[k];
    
            try {
                stack.replace(info.url, args);
            } catch (e) {
                return;
            }

            focus = true;
            targetIndex = index;
        }
    }

    onCurrentIndexChanged: {
        stack.switchTo(currentIndex);
    }

    Keys.onPressed: {
        switch (event.key) {
        case Qt.Key_Left: {
            if (self.currentIndex < 1)
                return;
            event.accepted = true;
            self.currentIndex--;
            break;
        }
        case Qt.Key_Right: {
            if (self.currentIndex >= tabs.count - 1)
                return;
            event.accepted = true;
            self.currentIndex++;
            break;
        }
        }
    }

    Component.onCompleted: {
        currentIndex = 0;
    }
}
