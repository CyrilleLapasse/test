import QtQuick 1.1
import "componentcache.js" as Priv

QtObject {
    id: self

    property int size: 3;

    function add(url, cb)
    {
        return Priv.add(url, cb);
    }

    function instanciate(url, parent, defaults)
    {
        return Priv.instanciate(url, parent, defaults);
    }
}
