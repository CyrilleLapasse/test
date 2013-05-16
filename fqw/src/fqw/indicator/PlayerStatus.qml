import QtQuick 1.1

Item {
    /*** Public API */
    property string status: "stop";

    implicitWidth: 30;
    implicitHeight: 30;

    /*** Private */

    Image {
        smooth: true;
        source: "player/" + parent.status + ".png";
        fillMode: Image.PreserveAspectFit;
        anchors.fill: parent;
    }
}
