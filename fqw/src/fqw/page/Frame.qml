import QtQuick 1.1

Item {
    id: self
    property Item l: l
    property Item r: r

    Item {
        id: l
        width: self.width
        height: self.height
        anchors.right: self.left
    }

    Item {
        id: r
        width: self.width
        height: self.height
        anchors.left: self.right
    }

    onParentChanged: reparent();
    Component.onCompleted: reparent();

    function reparent()
    {
        l.parent = parent;
        r.parent = parent;
    }
}
