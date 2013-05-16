import QtQuick 1.1

QtObject {
    id: binder;

    property bool valid: false;

    property Item owner: parent;
    property string prop;

    property bool asynchronous: false;
    property bool workInProgress: false;

    function didLoad(success, value) {
        workInProgress = false;

        binder.valid = success;
        if (success) {
            priv.value = value;
        } else {
            console.log("Failed to load setting value for", binder.owner, binder.prop)
        }
    }

    function didSave(success) {
        workInProgress = false;

        if (!success) {
            console.log("Failed to save setting value for", binder.owner, binder.prop)
            priv.value = priv.oldValue;
        }
    }

    property QtObject _priv: QtObject {
        id: priv;

        property bool propagateChangesToOwner: false;
        property variant oldValue;
    
        property variant value: null;
        onValueChanged: {
            if (priv.propagateChangesToOwner && owner)
                binder.owner[binder.prop] = value;
        }

        function ownerSignalName() {
            return binder.prop + "Changed";
        }

        function save() {
            oldValue = value;

            if (binder.owner[binder.prop] == value)
                return;

            value = binder.owner[binder.prop];

            if (asynchronous) {
                binder.workInProgress = true;
                binder.asyncSave(value);
            } else {
                var success = false;
                try {
                    binder.setValue(value);
                    success = true;
                } catch(e) {
                    console.log("  >", e);
                }
    
                binder.didSave(success);
            }
        }

        function load() {
            if (asynchronous) {
                binder.workInProgress = true;
                binder.asyncLoad();
            } else {
                var success = false;
                var loaded;
                try {
                    loaded = binder.getValue();
                    success = true;
                } catch (e) {
                    console.log("  >", e);
                }

                binder.didLoad(success, loaded);
            }
        }

        function bind() {
            binder.owner[ownerSignalName()].connect(priv, save);
        }

        function unBind() {
            binder.owner[ownerSignalName()].disconnect(priv, save);
        }
    }

    Component.onCompleted: {
        priv.bind();
        priv.propagateChangesToOwner = true;
        priv.load();
    }

    Component.onDestruction: {
        priv.unBind();
    }
}
