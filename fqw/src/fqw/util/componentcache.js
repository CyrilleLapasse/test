
var lru = [];
var components = {};
var callbacks = {};
var urlmap = {};

function touch(url)
{
    var i = lru.indexOf(url);
    if (i >= 0)
        lru.splice(i, 1);

    lru.splice(0, 0, url);

    cleanup();
}

function remove(url)
{
    var i = lru.indexOf(url);
    if (i >= 0)
        lru.splice(i, 1);

    delete(components[url]);
}

function statusChanged()
{
    var c = this;
    var url = urlmap[c.url];
    var cb = callbacks[c.url];

    switch (c.status) {
    case Component.Ready:
        c.statusChanged.disconnect(c, statusChanged);
        touch(url);

        delete urlmap[c.url];
        if (cb) {
            delete callbacks[c.url];
            cb(url, undefined);
        }
        return;

    case Component.Loading:
    case Component.Null:
        return;

    case Component.Error:
        c.statusChanged.disconnect(c, statusChanged);
        remove(url);

        delete urlmap[c.url];
        if (cb) {
            delete callbacks[c.url];
            cb(url, c.errorString());
        }
        return;
    }
}

function add(url, cb)
{
    if (components[url] !== undefined) {
        touch(url);

        cb(url, undefined);
        return;
    }

    var c = Qt.createComponent(url);
    callbacks[c.url] = cb;
    urlmap[c.url] = url;
    components[url] = c;

    touch(url);

    c.statusChanged.connect(c, statusChanged);
    statusChanged.apply(c);
}

function cleanup()
{
    for (var i = lru.length - 1; self.size <= i; --i)
        remove(lru[i]);
}

function instanciate(url, parent, defaults)
{
    var c = components[url];

    if (c === undefined)
        return null;

    if (c.status != Component.Ready)
        return null;

    return c.createObject(parent, defaults || {});
}
