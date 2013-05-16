import QtQuick 1.1

QtObject {
    id: group;

    property variant value: null;
    property bool canUnselect: false;

    function reset()
    {
        for (var i = 0; i < items.length; i++) {
            var item = items[i];

            priv.disconnect(item);
            item.exclusiveGroup = null;
        }
    
        priv.items = [];
        priv.selectedItem = null;
        value = null;
    }

    function __add(item)
    {
        priv.add(item);
    }

    property QtObject _priv: QtObject {
        id: priv

        property variant items: [];
        property Item selectedItem: null;
        property bool inited: false;

        function disconnect(item)
        {
            item.exclusiveGroupChanged.disconnect(item, priv.handleExclusiveGroupChanged);
            item.enabledChanged.disconnect(item, priv.handleItemChanged);
            item.checkedChanged.disconnect(item, priv.handleItemChanged);
        }

        function connect(item)
        {
            item.exclusiveGroupChanged.connect(item, priv.handleExclusiveGroupChanged);
            item.enabledChanged.connect(item, priv.handleItemChanged);
            item.checkedChanged.connect(item, priv.handleItemChanged);
        }
        
        function add(item)
        {
            var _items = items;
            _items.push(item);
            items = _items;

            if (item.checked && item.enabled)
                check(item);
            else if (items.length == 1 && inited)
                check(item);
        
            connect(item);
        }

        function selectSomething()
        {
            var candidates = [];

            for (var i = 0; i < items.length; i++) {
                var item = items[i];

                if (item.enabled)
                    candidates.push(item);
            }

            if (candidates.length) {
                check(candidates[0]);
            } else if (canUnselect) {
                group.value = null;
                priv.selectedItem = null;
            } else {
                group.value = null;
                priv.selectedItem = null;

                throw new Error("No candidates and no null selection possible !");
            }
        }

        function handleExclusiveGroupChanged()
        {
            var item = this;

            if (item.checkGroup === group)
                return;

            var index = items.indexOf(item);
            if (index == -1)
                return;

            disconnect(item);

            var _items = items;
            _items.splice(index, 1);
            items = _items;

            if (item === priv.selectedItem)
                selectSomething();
        }
        
        function handleItemChanged()
        {
            var item = this;

            if (selectedItem && item.enabled && (item === selectedItem) == item.checked)
                return;

            if (!item.enabled && !item.checked)
                return;

            if (!item.enabled)
                item.checked = false;

            if (item.checked || (item.enabled && !selectedItem)) {
                check(item);
            } else if (!group.canUnselect && item.enabled) {
                item.checked = true;
            } else {
                selectSomething();
            }
        }

        function check(item)
        {
            var currentItem = selectedItem;
            selectedItem = item;
            if (currentItem)
                currentItem.checked = false;
            item.checked = true;
            group.value = item.value;
        }

        Component.onCompleted: {
            inited = true;

            if (selectedItem === null)
                selectSomething();
        }
    }
}
