
var stack = [];
var nextStack = [];

var elements = {};

var componentsToLoad = 0;
var nextUid = 1;

var commitExpected = false;


function title_list_update() {
    var i;

    for (i = 0; i < stack.length; ++i) {
        var t = get(i).title;

        if (i >= titleList.count)
            titleList.append({title: t});
        else if (t != titleList.get(i).title)
            titleList.setProperty(i, "title", t);
    }

    while (titleList.count > stack.length)
        titleList.remove(titleList.count - 1);
}

function elem_update(elem)
{
    try {
        elem.state = elem.instance.serialize();
    } catch (e) {
        elem.state = '{}';
    }

    if (elem.instance && elem.instance.title)
        elem.title = elem.instance.title;

    title_list_update();
}

function elem_deinstanciate(elem, save)
{
    if (!elem.instance)
        return;

    if (save)
        elem_update(elem);
    elem.instance.destroy();
    elem.instance = null;
}

function elem_instanciate(elem, parent)
{
    /* Use defaults */
    var p = {}
    for (var k in elem.defaults)
        p[k] = elem.defaults[k];

    /* Update with last known state */
    try {
        var st = JSON.parse(elem.state);
        for (var k in st)
            p[k] = st[k];
    } catch (e) {
    }

    if (elem.instance === null)
        elem.instance = componentCache.instanciate(elem.url, parent, p);
    elem_update(elem);
}



function cleanup(topCount)
{
    for (var i in elements) {
        var elem = elements[i];
        var uid = elem.uid;

        if (stack.indexOf(uid) >= 0)
            continue;

        elem_deinstanciate(elem, false);
        delete(elements[i]);
    }

    if (topCount == 0)
        return;

    for (var i = 0; i < stack.length - topCount; ++i) {
        var elem = elements[stack[i]];

        elem_deinstanciate(elem, true);
    }
}

function commit(run)
{
    if (componentsToLoad) {
        commitExpected |= run;
        return;
    }

    if (!commitExpected && !run)
        return;

    commitExpected = false;

    stack = nextStack;
    nextStack = [];
    for (var i in stack)
        nextStack.push(stack[i]);
    self.count = stack.length;

    changedLater.start();
}

function baseUrl()
{
    var url = self.baseUrl;

    if (stack.count)
        url = stack.get(-1).url;

    var index = url.lastIndexOf("/");
    if (index >= 0)
        return url.substr(0, index + 1);
    else
        return url + "/";
}

function absUrl(url)
{
    var pos = url.search("://");

    if (pos < 5 && pos > 0)
        return url;

    if (url.substr(0,1) == "/")
        return url;

    return baseUrl() + url;
}

function push(url, defaults)
{
    url = absUrl(url);

    var ext = url.substring(url.length - 4);
    if (ext != ".qml")
        url = url + ".qml";

    var uid = nextUid++;
    var elem = {
        url: url,
        defaults: defaults,
        uid: uid,
        instance: null,
        title: "",
        state: ""
    };
    elements[uid] = elem;

    nextStack.push(uid);

    loadTipUrl();
}

function loadTipUrl()
{
    for (var i = Math.max(nextStack.length - topCount, 0);
         i < nextStack.length; ++i) {
        var elem = elements[nextStack[i]];
        var url = elem.url;

        componentsToLoad++;

        componentCache.add(url, function(url, error) {

        if (error) {
            removeUrl(url);
            self.componentError(url, error);
        }

        --componentsToLoad;

        commit(false);
        });
    }
}

function popTo(index)
{
    nextStack.splice(index + 1, nextStack.length);
    loadTipUrl();
}

function pop()
{
    nextStack.pop();
    loadTipUrl();
}

function get(i)
{
    if (i < 0)
        i = stack.length + i;

    if (i >= stack.length)
        return null;

    return elements[stack[i]];
}

function updateItem(item)
{
    for (var i = stack.length - 1; i >= 0; --i) {
        var elem = stack[i];

        if (item !== elem.instance)
            continue;

        elem_update(elem);

        return;
    }
}

function instanciate(i, parent)
{
    var elem = get(i);

    if (!elem)
        return null;

    elem_instanciate(elem, parent)

    return elem.instance;
}

function removeUrl(url)
{
    for (var i = stack.length - 1; i >= 0; --i)
        if (url == stack[i].url)
            stack.splice(i, 1);
}
