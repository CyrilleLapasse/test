
function target(parent, current, target_angle)
{
    var center = {
        x: current.width / 2,
        y: current.height / 2
    };
    var next = null;
    var next_dist = 1000000;

    for (var i = 0; i < parent.children.length; ++i) {
        var item = parent.children[i];

        if (!self.isItemFocusable(item) || !item.visible || item.focus)
            continue;

        var pos = current.mapToItem(item, item.width / 2, item.height / 2);
        var distance = (pos.x - center.x) * (pos.x - center.x) + (pos.y - center.y) * (pos.y - center.y);
        var angle = Math.floor(Math.atan2(pos.y - center.y, center.x - pos.x) / Math.PI * 180);

        var angle_delta = ((angle - target_angle + 180 + 360) % 360) - 180;

        if (angle_delta <= -90 || angle_delta >= 90)
            continue;

        var fact = Math.sin(angle_delta / 180. * Math.PI);
        distance /= 1 - fact * fact;

        if (distance >= next_dist)
            continue;

        next = item;
        next_dist = distance;
    }

    return next;
}

function getCurrent(parent)
{
    for (var i = 0; i < parent.children.length; ++i) {
        var item = parent.children[i];

        if (item.focus)
            return item;
    }

    return null;
}

function getFirst(parent)
{
    for (var i = 0; i < parent.children.length; ++i) {
        var item = parent.children[i];

        if (!self.isItemFocusable(item) || !item.visible || item.focus)
            continue;

        return item;
    }

    return null;
}

function pressed(event)
{
    var next = null;
    var current = getCurrent(self.root);

    if (!current) {
        next = getFirst(self.root);
    } else {
        switch (event.key) {
        case Qt.Key_Up:
            next = target(self.root, current, 90);
            break;
        case Qt.Key_Down:
            next = target(self.root, current, -90);
            break;
        case Qt.Key_Left:
            next = target(self.root, current, 180);
            break;
        case Qt.Key_Right:
            next = target(self.root, current, 0);
            break;
        }
    }

    if (next) {
        event.accepted = true;
        next.focus = true;
        return true;
    }

    return false;
}
