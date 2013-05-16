import QtQuick 1.1
import "JsonListLoader.js" as Priv

QtObject {
    id: self

    property string baseUrl
    property int uid: 1

    signal changed();

    function getNode(node)
    {
        if (node == undefined)
            node = {
                uid: 0,
                directory_content_url: "root.json",
                type: "directory"
            };

        return Priv.getNodeData(node);
    }

    onChanged: {
        Priv.reset();
    }
}
