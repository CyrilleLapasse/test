import QtQuick 1.1
import fqw.page 1.0
import fqw.log 1.0

Page {
    id: self
    objectName: "fqw.application.Application"
    anchors.fill: parent
    focus: true

    state: "starting"

    property string title: "Application"

    property variant context

    property Log log: Log { section: title }

    signal resignFocus()

    function handleUrl(url)
    {
        console.log("Application", name, "unable to open url", url);
    }

    Keys.onPressed: {
        switch (event.key) {
        case Qt.Key_Escape:
        case Qt.Key_Back: {
            resignFocus();
            event.accepted = true;
            break;
        }
        }
    }
}
