import QtQuick 1.1

FocusScope {
    id: page
    anchors.fill: parent

    /** Public API */

    // Accessor to current page stack
    property Item stack
    property string title: ""

    // Signals display events
    signal willAppear()
    signal didAppear()
    signal willDisappear()
    signal didDisappear()

    // Persistent property names
    property variant persistentProperties: []

    function parentStack(level)
    {
        return stack.parentStack(level);
    }

    function push(url, properties) {
        return stack.push(url, properties);
    }

    function pop() {
        return stack.pop();
    }

    function replace(url, properties) {
        return stack.replace(url, properties);
    }

    function serialize() {
        var ret = {};

        for (var k in page.persistentProperties) {
            var name = page.persistentProperties[k];

            try {
                ret[name] = page[name];
            } catch (e) {
            }
        }

        return JSON.stringify(ret);
    }
}
