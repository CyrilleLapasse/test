import QtQuick 1.1
import fqw.page 1.0

Explorer {
    id: dataExplorer

    property string delegateBaseUrl: "./"
    property string dataBaseUrl
    property string dataRoot: "root.json"
    property alias data: data

    JsonListLoader {
        id: data
        baseUrl: dataBaseUrl

        onChanged: {
            dataExplorer.reset();
        }
    }

    baseUrl: Qt.resolvedUrl(delegateBaseUrl)

    Keys.onLeftPressed: pop();

    function pushNode(nodeInfo) {
        var n = data.getNode(nodeInfo);
        push(delegateBaseUrl + n.type + "_page.qml", {node: n});
    }

    Component.onCompleted: {
        reset();
    }

    function reset() {
        var nodeInfo = data.getNode();
        var n = data.getNode(nodeInfo);
        replaceAt(0, delegateBaseUrl + n.type + "_page.qml", {node: n});
    }
}
