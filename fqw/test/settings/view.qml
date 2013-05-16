import QtQuick 1.1
import fqw.setting 1.0 as Setting
import fqw.page 1.0 as Page

Page.Page {
    implicitWidth: 640
    implicitHeight: 480
    focus: true
    title: "Settings"
    persistentProperties: ["stackState"]

    Setting.View {
        id: view;
        anchors.fill: parent;
        baseUrl: Qt.resolvedUrl(".");
        initialPage: "demo.qml";
    }
}
