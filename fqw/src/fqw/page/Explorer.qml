import QtQuick 1.1
import fqw.controller 1.0
import fqw.util 1.0

FocusScope {
    id: self

    objectName: "fqw.page.PageStack"

    property alias baseUrl: stack.baseUrl
    property int duration: 300

    property bool canPopRoot: false
    property alias depth: stack.count

    property alias cachedPages: stack.topCount

    property string initialPage: ""

    property alias titleList: stack.titleList

    implicitWidth: parent ? parent.width : 0
    implicitHeight: parent ? parent.height : 0

    ComponentListModel {
        id: stack

        baseUrl: "./"
        cacheSize: 2

        onComponentError: {
            console.log(self, "Component loading error:", url, error);
        }

        property int lastCount: 0
        topCount: 2

        function getContainer(excludedContainer)
        {
            var containers = [container0, container1, container2, container3];

            for (var i = 0; i < 4; ++i) {
                var c = containers[i];
                if (c == excludedContainer)
                    continue;
                if (c == leftContainer)
                    continue;
                if (c == rightContainer)
                    continue;
                return c;
            }

            return null;
        }

        onChanged: {
            inProgress = true;

            focusHolder.focus = true;

            var pushing = stack.count > lastCount;
            var popping = stack.count < lastCount;
            var ratio = 0;

            /* Containers for items */

            var nextLeftContainer = getContainer();
            var nextRightContainer = getContainer(nextLeftContainer);

            /* Items, some may already be present in explorer view */

            var nextLeftItem = instanciate(-1, objectPool);
            var nextRightItem = null;

            if (nextLeftItem) {
                nextLeftItem.focus = false;
                nextRightItem = nextLeftItem.companionView;
            }

            /* Compute ratios */

            if (nextRightItem) {
                nextRightItem.focus = false;
                nextRightItem.parent = nextRightContainer;

                ratio = .5;

                if (nextRightItem.ratio !== undefined)
                    ratio = nextRightItem.ratio;
            } else {
                nextRightItem = null;
                nextRightContainer = null;
            }

            /* Align stack top on right edge of screen */

            if (!nextLeftItem)
                nextLeftContainer = null;

            /* Parenting and position */

            if (nextLeftItem)
                nextLeftItem.parent = nextLeftContainer;

            if (nextRightItem)
                nextRightItem.parent = nextRightContainer;

            if (nextLeftContainer)
                nextLeftContainer.moveTo(
                    pushing ? (rightContainer && nextRightItem ? oframe2 : frame1.r) : frame1.l,
                    false, 0);
            if (nextRightContainer)
                nextRightContainer.moveTo(
                    popping ? (leftContainer ? oframe1 : frame2.l) : frame2.r,
                    false, 0);

            frame1.width = self.width * (1 - ratio);

            /* Animate entering containers */

            if (nextLeftContainer)
                nextLeftContainer.moveTo(frame1, true, 1);

            if (nextRightContainer)
                nextRightContainer.moveTo(frame2, true, 1);

            /* Animate leaving containers */

            if (leftContainer)
                leftContainer.moveTo(
                    popping ? (nextRightContainer ? frame2 : oframe1.r) : oframe1.l,
                    true, 0);

            if (rightContainer)
                rightContainer.moveTo(
                    pushing ? (nextLeftContainer ? frame1 : oframe2.l) : oframe2.r,
                    true, 0);

            /* Signals */

            if (nextLeftItem && nextLeftItem !== leftItem && nextLeftItem !== rightItem) {
                nextLeftItem.willAppear();
                newLeftItem = nextLeftItem;
            }

            if (leftItem && leftItem !== nextLeftItem && leftItem !== nextRightItem) {
                leftItem.willDisappear();
                oldLeftItem = leftItem;
            }

            /* Groundwork for next animation */

            leftContainer = nextLeftContainer;
            rightContainer = nextRightContainer;

            oldRightItem = rightItem;

            leftItem = nextLeftItem;
            rightItem = nextRightItem;

            lastCount = stack.count;
            toggle = !toggle;
        }

        property bool toggle: false

        property Item frame1: toggle ? frame01 : frame11
        property Item frame2: toggle ? frame02 : frame12
        property Item oframe1: toggle ? frame11 : frame01
        property Item oframe2: toggle ? frame12 : frame02

        property Item oldLeftItem
        property Item newLeftItem
        property Item oldRightItem
        property Item leftItem
        property Item rightItem

        property Container leftContainer
        property Container rightContainer

        property bool inProgress: false;

        property Binding b: Binding {
            when: !stack.inProgress
            value: stack.rightItem
                ? (self.width * (1 - stack.rightItem.ratio))
                : self.width;
            target: stack.oframe1
            property: "width"
        }

        function finish() {
            if (!inProgress)
                return;
            inProgress = false;

            if (leftItem)
                leftItem.focus = true;

            if (leftContainer)
                leftContainer.focus = true;

            if (leftContainer.activeFocus)
                leftContainer.forceActiveFocus();

            if (oldLeftItem) {
                oldLeftItem.parent = objectPool;
                oldLeftItem.didDisappear();
            }

            if (oldRightItem) {
                oldRightItem.parent = objectPool;
            }

            if (newLeftItem)
                newLeftItem.didAppear();

            oldLeftItem = null;
            newLeftItem = null;

            cleanup();
        }
    }

    onFocusChanged: {
        // Workaround QML focus bug
        if (stack.leftContainer)
            stack.leftContainer.focus = true;
    }

    Item {
        id: objectPool
        objectName: "objectPool"
        width: parent.width
        height: parent.height
        enabled: false
        clip: true
        x: -parent.width
    }

    Frame {
        id: frame01
        objectName: "frame01"
        anchors.left: parent.left
        height: parent.height
    }

    Frame {
        id: frame02
        objectName: "frame02"
        anchors.right: parent.right
        height: parent.height
        width: parent.width - frame01.width
    }

    Frame {
        id: frame11
        objectName: "frame11"
        anchors.left: parent.left
        height: parent.height
    }

    Frame {
        id: frame12
        objectName: "frame12"
        anchors.right: parent.right
        height: parent.height
        width: parent.width - frame11.width
    }

    Container {
        id: container0
        objectName: "container0"
        duration: self.duration
        onAnimationFinished: stack.finish()
    }

    Container {
        id: container1
        objectName: "container1"
        duration: self.duration
        onAnimationFinished: stack.finish()
    }

    Container {
        id: container2
        objectName: "container2"
        duration: self.duration
        onAnimationFinished: stack.finish()
    }

    Container {
        id: container3
        objectName: "container3"
        duration: self.duration
        onAnimationFinished: stack.finish()
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
            index = Math.max(index, 0);

        stack.popTo(index);
    }

    function pop()
    {
        if (stack.inProgress)
            throw "Transition in progress";

        if (canPopRoot || stack.count > 1) {
            stack.pop();
        }
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

    function replaceAt(index, url, props)
    {
        if (stack.inProgress)
            throw "Transition in progress";

        if (props === undefined)
            props = {}

        props.stack = self;

        stack.replaceAt(index, url, props);
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
