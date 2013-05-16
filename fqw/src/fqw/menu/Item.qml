import QtQuick 1.1
import fqw.util 1.0

FocusScope {
    id: widget
    objectName: "fqw.menu.Item"
    enabled: false

    function view()
    {
        var w = widget;
        while (w && w.objectName != "fqw.menu.View")
            w = w.parent;
        return w;
    }

    function pop()
    {
        return view().pop();
    }

    function close()
    {
        return view().close();
    }

    function push(x)
    {
        return view().push(x);
    }

    height: 40
    width: parent ? parent.width : 40
}
