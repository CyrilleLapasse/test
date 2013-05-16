import QtQuick 1.1
import "componentlistmodel.js" as Priv

QtObject {
    id: self

    signal changed();
    signal componentError(string url, string error);

    property int count: 0
    property int topCount: 0
    property alias cacheSize: componentCache.size
    property variant cachedProperties: []
    property string baseUrl: "./"

    function cleanup()
    {
        return Priv.cleanup(topCount);
    }

    function instanciate(i, parent)
    {
        return Priv.instanciate(i, parent);
    }

    function getProperty(i, name)
    {
        return Priv.getProperty(i, name);
    }

    function push(url, defaults)
    {
        var uid = Priv.push(url, defaults);
        Priv.commit(true);
        return uid;
    }

    function pop()
    {
        if (count == 0)
            return;

        Priv.pop();
        Priv.commit(true);
    }

    function popTo(index)
    {
        // Noop
        if (index + 1 == count)
            return;

        Priv.popTo(index);
        Priv.commit(true);
    }

    function replace(url, defaults)
    {
        Priv.pop();
        var uid = Priv.push(url, defaults);
        Priv.commit(true);
        return uid;
    }

    function replaceAt(index, url, defaults)
    {
        Priv.popTo(index - 1);
        var uid = Priv.push(url, defaults);
        Priv.commit(true);
        return uid;
    }

    property ComponentCache _componentCache: ComponentCache {
        id: componentCache
    }

    property Timer _timer: Timer {
        id: changedLater
        interval: 10
        onTriggered: self.changed()
    }

    property QtObject titleList: ListModel {
    }
}
