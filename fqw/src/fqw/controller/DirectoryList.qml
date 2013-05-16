import QtQuick 1.1
import fqw.internal 1.0

GridView {
    id: self

    anchors.margins: 10

    clip: true
    snapMode: GridView.NoSnap
    preferredHighlightBegin: .1 * height
    preferredHighlightEnd: .9 * height
    highlightRangeMode: GridView.ApplyRange

    cellWidth: (count && currentItem ? currentItem.width : 40) + 5
    cellHeight: (count && currentItem ? currentItem.height : 40) + 5

    property string delegateBaseUrl: dataExplorer.delegateBaseUrl
    property string viewType: ""

    onCountChanged: {
        viewType = node.preferred_item_view_type || "";
        self.positionViewAtIndex(currentIndex, GridView.Beginning);
    }

    onActiveFocusChanged: {
        self.positionViewAtIndex(currentIndex, GridView.Center);
        if (self.currentItem && activeFocus)
            self.currentItem.focus = true;
    }

    property variant node
    model: node ? node.content : null

    highlightMoveDuration: 100

    highlight: StandardAsset {
        visible: GridView.view ? GridView.view.activeFocus : false
        background: "CC0000"
    }

    delegate: ElementView {
        delegateBaseUrl: GridView.view.delegateBaseUrl;
        node: dataExplorer.data.getNode(self.model.get(index));
        property int itemIndex: index
        viewType: GridView.view.viewType

        Keys.onPressed: {
            var oneColumn = GridView.view.width / GridView.view.cellWidth < 2;

            switch (event.key) {
            case Qt.Key_Enter:
            case Qt.Key_Return: {
                event.accepted = true;
                self.enter();
                break;
            }
            case Qt.Key_Left: {
                if (!oneColumn)
                    break;
                event.accepted = true;
                pop();
                break;
            }
            case Qt.Key_Right: {
                if (!oneColumn)
                    break;
                event.accepted = true;
                self.enter();
                break;
            }
            }
        }
    }

    function enter()
    {
        var nodeInfo = self.model.get(self.currentIndex);
        dataExplorer.pushNode(nodeInfo);
    }
}
