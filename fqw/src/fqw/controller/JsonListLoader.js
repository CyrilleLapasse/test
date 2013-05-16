
var nodeCache = {};

function NodeInfo(root, initial_data)
{
    this.root = root;
    this.content = Qt.createQmlObject("import QtQuick 1.1\nListModel {}", this.root);

    this.updateData(initial_data);
    if (this.directory_content_url)
        this.fetchContent();
}

NodeInfo.prototype.updateDirContent = function (data)
{
    for (var k in data) {
        var d = data[k];

        if (k == "content")
            this.loadDirContentContent(d);
        else
            this[k] = d;
    }
};

NodeInfo.prototype.updateData = function (data)
{
    for (var k in data) {
        var d = data[k];

        if (k == "directory_content")
            this.updateDirContent(d);
        else
            this[k] = d;
    }
};

NodeInfo.prototype.loadDirContentContent = function(directory_content)
{
    this.content.clear();

    for (var i in directory_content) {
        var e = directory_content[i];

        e.uid = this.root.uid++;

        this.content.append(e);
    }
};

NodeInfo.prototype.readyStateChanged = function()
{
    var req = this.req;
    delete this.req;
};

NodeInfo.prototype.fetchContent = function()
{
    var url = this.root.baseUrl + this.directory_content_url;
    var node_info = this;

    var req = new XMLHttpRequest();

    req.onreadystatechange = function () {
        if (req.readyState == XMLHttpRequest.DONE) {
            if (req.status >= 400) {
                self.changed();
            } else if (req.status < 300) {
                try {
                    var data = JSON.parse(req.responseText);
                    node_info.updateDirContent(data);
                } catch (e) {
                    console.log("Error while fetching", url, e);
                }
            } else {
                console.log("Error while fetching", url, req.status);
            }
        }
    };

    req.open("GET", url);
    req.send();
};

function getNodeData(node)
{
    if (nodeCache[node.uid])
        return nodeCache[node.uid];

    var obj = new NodeInfo(self, node);
    delete node.directory_content;

    nodeCache[node.uid] = obj;
    return obj;
}

function reset()
{
    nodeCache = {};
}
