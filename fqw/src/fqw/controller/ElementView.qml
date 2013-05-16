import QtQuick 1.1

Loader {
    id: self

    property string delegateBaseUrl: dataExplorer.delegateBaseUrl
    property string viewType: ""
    property variant node

    source: node ? delegateBaseUrl + viewName(node, viewType) + ".qml" : ""

    function viewName(n, v) {
        if (!n)
            return ""

        var name = "_";

        if (n.type)
            name += n.type + "_";
        else if (n.item_type)
            name += n.item_type + "_";

        if (v)
            name += v + "_";

        return name.substring(1, name.length-1);
    }

    onStatusChanged: {
        if (status == Loader.Error) {
            console.log("Unimplemented element view:", viewName(self.node));
        }
    }

    Binding {
        target: self.item
        when: self.status == Loader.Ready
        property: "node"
        value: self.node ? self.node : null
    }

    Binding {
        target: self
        when: self.status == Loader.Ready
        property: "implicitHeight"
        value: self.item ? self.item.height : 40
    }
}
