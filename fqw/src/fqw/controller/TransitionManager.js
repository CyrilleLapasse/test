
var nextUid = 1;
var currentFrame = null;
var transitionInProgress = false;

function frameDismissed()
{
    var frame = this;

    frame.animationComplete.disconnect(frame, frameDismissed);

    //console.log(frame, "dismissed", frame.item, frame.autoDelete);

    if (frame.focus)
        focusPlaceholder.focus = true;

    frame.item.parent = objectPool;
    previousItem = frame.item;
    frame.item = null;

    var uid = frame.uid;
    var ad = frame.autoDelete;
    
    frame.destroy();

    widget.didHideItem(uid);

    if (ad)
        previousItem.destroy(widget.getPreviousItem());
}

function frameNowMain()
{
    var frame = this;

    frame.animationComplete.disconnect(frame, frameNowMain);

    //console.log(frame, "now main", frame.item);

    currentFrame = frame;
    frame.focus = true;
    widget.currentItem = frame.item;

    widget.didShowItem(frame.uid);

    transitionInProgress = false;
}

function animateSwitch(nextFrame, animation)
{
    focusPlaceholder.focus = true;

    //console.log("Switching from", currentFrame, currentFrame ? currentFrame.state : "?",
    //            "to", nextFrame, nextFrame ? nextFrame.state : "?")

    if (nextFrame)
        widget.nextItem = nextFrame.item;
    else
        widget.nextItem = null;

    widget.willSwitchItems(currentFrame ? currentFrame.uid : -1,
                           nextFrame ? nextFrame.uid : -1)

    widget.currentItem = null;
    widget.nextItem = null;

    if (currentFrame !== null) {
        currentFrame.animationComplete.connect(currentFrame, frameDismissed);
        currentFrame.state = Animation.animationDestinationState(animation);

        if (nextFrame === null) {
            // We dont really care for another animation now there is
            // nothing left
            currentFrame = null;
            transitionInProgress = false;
        }
    }

    if (nextFrame !== null) {
        //console.log(widget, 'animating', nextFrame, nextFrame.state);
        nextFrame.animationComplete.connect(nextFrame, frameNowMain);
        nextFrame.state = "main";
    }
}

function switchToItem(item, animation, compUid)
{
    if (item === null) {
        animateSwitch(null, animation);
        return -1;
    }

    if (transitionInProgress)
        throw new Error("Transition already in progress");

    //console.log("Switching to", item, animation)

    transitionInProgress = true;

    var sourceState = Animation.animationSourceState(animation);
    var uid = compUid;
    if (!compUid)
        uid = nextUid++;

    var props = {
        state: sourceState,
        animation: animation,
        uid: uid,
        autoDelete: !!compUid
    };

    Animation.applyState(props, widget.width, sourceState);
    
    var frame = frameComponent.createObject(widget, props);

    //console.log(" -> Frame ready", frame, frame.item)

    frame.item = item;
    item.parent = frame;
    if (item && item.anchors)
        item.anchors.fill = frame;

    animateSwitch(frame, frame.animation);

    return uid;
}

var componentCreationArgs = {};
var componentAnimation = "";
var componentUid = -1;

function checkComponentReady()
{
    var component = this;

    //console.log(" -> new status:", component, component.status)

    switch (component.status) {
    case Component.Null:
        //console.log(" -> component null")
        return;

    case Component.Loading:
        //console.log(" -> component loading")
        return;

    case Component.Ready: {
        //console.log(" -> component ready")
        widget.componentLoaded(componentUid);
        var obj = component.createObject(objectPool, componentCreationArgs);
        transitionInProgress = false;
        switchToItem(obj, componentAnimation, componentUid);
        break;
    }
        
    case Component.Error: {
        //console.log(" -> component error")
        transitionInProgress = false;
        widget.componentFailed(componentUid, component.errorString());
        break;
    }
    }

    component.statusChanged.disconnect(component, checkComponentReady);
}

function switchToComponent(component, args, animation)
{
    if (transitionInProgress)
        throw new Error("Transition already in progress");

    //console.log("Creating component", component)

    transitionInProgress = true;

    componentAnimation = animation;
    componentCreationArgs = args;
    componentUid = nextUid++;

    var component = Qt.createComponent(component);
    component.statusChanged.connect(component, checkComponentReady);

    //console.log(" -> Created:", component)

    checkComponentReady.apply(component)

    return componentUid;
}
