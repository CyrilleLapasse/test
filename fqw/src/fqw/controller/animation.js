.pragma library

function animationSourceState(animation)
{
    switch (animation) {
        case "slideRight": return "left";
        case "slideLeft": return "right";
        case "scaleUp": return "shrunk";
        case "scaleDown": return "magnified";
        case "fade": return "transparent";
        case "appear": return "hidden";
        default: return "left";
    }
}

function animationDestinationState(animation)
{
    switch (animation) {
        case "slideRight": return "right";
        case "slideLeft": return "left";
        case "scaleUp": return "magnified";
        case "scaleDown": return "shrunk";
        case "fade": return "transparent";
        case "appear": return "hidden";
        default: return "right";
    }
}

function animationReverse(animation)
{
    switch (animation) {
        case "slideRight": return "slideLeft";
        case "slideLeft": return "slideRight";
        case "scaleUp": return "scaleDown";
        case "scaleDown": return "scaleUp";
        default: return animation;
    }
}

function animationProperties(state)
{
    switch (state) {
        case "main":
        return {
            xWidthScale: 0,
            opacity: 1,
            scale: 1,
            visible: true
        };

        case "left":
        return {
            xWidthScale: -1
        };

        case "right":
        return {
            xWidthScale: 1
        };

        case "shrunk":
        return {
            scale: .8,
            opacity: 0
        };

        case "magnified":
        return {
            scale: 1.2,
            opacity: 0
        };

        case "transparent":
        return {
            opacity: 0
        };

        case "hidden":
        return {
            visible: false
        };

    }

    return {};
}

function applyState(item, width, state)
{
    var transforms = animationProperties(state);

    for (var i in transforms) {
        var val = transforms[i];
        if (i == "xWidthScale")
            item["x"] = val * width;
        else
            item[i] = val;
    }
}
