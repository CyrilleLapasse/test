import QtQuick 1.1
import "animation.js" as Animation
import "TransitionManager.js" as Priv

FocusScope {
    id: widget

    property int duration: 300;
    property Item previousItem;
    property Item currentItem;
    property Item nextItem;

    // Called when item gets hidden
    signal didHideItem(int previousUid);
    // called when item appears
    signal didShowItem(int currentUid);
    // called when item switching begins
    signal willSwitchItems(int currentUid, int nextUid);

    // called when component gets loaded
    // Next action is switching items (automatic)
    signal componentLoaded(int uid);
    // If switchToComponent loads a broken component, this is called
    // with respective uid
    signal componentFailed(int uid, string error);

    // Returns an uid if item != null
    function switchToItem(item, animation)
    {
        return Priv.switchToItem(item, animation, false);
    }

    // Returns an uid
    function switchToComponent(component, args, animation)
    {
        return Priv.switchToComponent(component, args, animation);
    }

    function getPreviousItem()
    {
        var pi = previousItem;
        previousItem = null;
        return pi;
    }

    function animationReverse(a)
    {
        return Animation.animationReverse(a);
    }

    Item {
        id: focusPlaceholder
        focus: true;
    }

    Item {
        id: objectPool
        width: 0
        height: 0
        clip: true
    }

    onWidthChanged: {
        if (Priv.currentItem)
            Priv.currentItem.width = width
    }

    onHeightChanged: {
        if (Priv.currentItem)
            Priv.currentItem.height = height
    }

    Component {
        id: frameComponent;

        FocusScope {
            id: frame;

            width: parent ? parent.width : 40
            height: parent ? parent.height : 40

            property string state: "";
            property string animation: "";
            property int duration: 300;
            property Item item;
            property int uid: 0;
            property bool autoDelete: false;

            signal animationComplete();

            onStateChanged: {
                if (frame.uid == 0) // Component not created yet
                    return;

                item.focus = true;
                Animation.applyState(frame, frame.width, state);
                stateTimer.start();
            }

            Timer {
                id: stateTimer
                interval: frame.duration;
                onTriggered: frame.animationComplete();
            }

            Behavior on x {
                NumberAnimation { easing.type: Easing.InOutQuad; duration: frame.duration; }
            }
            Behavior on y {
                NumberAnimation { easing.type: Easing.InOutQuad; duration: frame.duration; }
            }
            Behavior on scale {
                NumberAnimation { easing.type: Easing.InCirc; duration: frame.duration; }
            }
            Behavior on opacity {
                NumberAnimation { easing.type: Easing.InOutQuad; duration: frame.duration; }
            }
        }
    }
}
