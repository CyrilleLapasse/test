import QtQuick 1.1
import fqw.controller 1.0
import fqw.util 1.0

FocusScope {
    id: self

    objectName: "fqw.page.Stack"

    property alias baseUrl: stack.baseUrl
    property alias duration: tm.duration

    property bool canPopRoot: false
    property alias depth: stack.count

    property string initialPage: ""
    property string animation: "slideLeft";

    property alias titleList: stack.titleList
    property alias cacheSize: stack.cacheSize
    property alias topSize: stack.topCount

    property Item tip

    implicitWidth: parent ? parent.width : 0
    implicitHeight: parent ? parent.height : 0

    ComponentListModel {
        id: stack

        baseUrl: "./"
        cacheSize: 1

        property int lastCount: 0

        onChanged: {
            inProgress = true;

            var pushing = stack.count > lastCount;
            lastCount = stack.count;

            var anim = self.animation;
            if (!pushing)
                anim = tm.animationReverse(anim);

            if (stack.count == 1 && pushing)
                anim = "appear";

            var n = stack.instanciate(-1, objectPool);
            if (n)
                n.willAppear();
            if (tm.currentItem)
                tm.currentItem.willDisappear();
            tm.switchToItem(n, anim);
        }

        onComponentError: {
            console.log(self, "Component loading error:", url, error);
        }

        property bool inProgress: false

        function finish(clean) {
            if (!inProgress)
                return;
            inProgress = false;

            if (clean)
                stack.cleanup();
        }
    }

    TransitionManager {
        id: tm
        anchors.fill: parent

        onDidHideItem: {
            if (tm.previousItem)
                tm.previousItem.didDisappear();
            stack.finish(true);
        }
        onDidShowItem: {
            if (tm.currentItem)
                tm.currentItem.didAppear();
            tm.focus = true;
            stack.finish(false);
            self.tip = tm.currentItem;
        }
    }

    Item {
        id: objectPool
        width: parent.width
        height: parent.height
        enabled: false
        clip: true
        x: -width
    }

    Item {
        id: focusHolder
        focus: true
    }

    function push(url, props)
    {
        if (stack.inProgress)
            throw "Transition in progress";

        if (props === undefined)
            props = {}

        props.stack = self;

        stack.push(url, props);
    }

    function popTo(index)
    {
        if (stack.inProgress)
            throw "Transition in progress";

        if (!canPopRoot)
            index = Math.max(index, 1);

        stack.popTo(index);
    }

    function pop()
    {
        if (stack.inProgress)
            throw "Transition in progress";

        if (canPopRoot || stack.count > 1) {
            if (stack.count == 1) {
                self.tip = null;
                focusHolder.focus = true;
            }

            stack.pop();
        }
    }

    function replaceAt(index, url, props)
    {
        if (stack.inProgress)
            throw "Transition in progress";

        if (props === undefined)
            props = {}

        props.stack = self;

        stack.replaceAt(index, url, props);
    }

    function replace(url, props)
    {
        if (stack.inProgress)
            throw "Transition in progress";

        if (props === undefined)
            props = {}

        props.stack = self;

        stack.replace(url, props);
    }

    function parentStack(level)
    {
        var item = self;

        while (item) {
            if (level == 0)
                return item;

            while (item.parent) {
                item = item.parent;

                if (item && item.objectName != self.objectName)
                    break;
            }

            level--;
        }

        return null;
    }

    Keys.onPressed: {
        switch (event.key) {
        case Qt.Key_Escape:
        case Qt.Key_Back: {
            if (stack.count <= (canPopRoot ? 0 : 1))
                return;
            event.accepted = true;
            pop();
        }
        }
    }

    Component.onCompleted: {
        if (initialPage)
            push(initialPage);
    }
}
