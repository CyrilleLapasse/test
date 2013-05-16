import QtQuick 1.1
import fqw.util 1.0

Item {
    id: outer;
    property real ratio: 0.;
    property string color: null;

    Item {
        clip: true;
        anchors.left: parent.left;
        anchors.top: parent.top;
        anchors.bottom: parent.bottom;

        width: outer.width * ratio;
    
        StandardAsset {
            background: outer.color;

            width: outer.width;
            degrade: true

            anchors {
                left: parent.left;
                top: parent.top;
                bottom: parent.bottom;
            }
        }
    }
}
