import QtQuick 1.1
import fqw.indicator 1.0

Item {
    width: 400
    height: 400

    Flickable {
        id: viewport

        contentX: 100
        contentY: 300

        contentWidth: 800
        contentHeight: 800

        Rectangle {
            width: 800
            height: 800

            gradient: Gradient {
                GradientStop { position: 0.0; color: "red" }
                GradientStop { position: 0.33; color: "yellow" }
                GradientStop { position: 1.0; color: "green" }
            }
        }

        anchors.fill: parent
    }

    Scrollbar {
        width: viewport.width / 10
        height: viewport.height / 10
        anchors.right: viewport.right
        anchors.bottom: viewport.bottom

        widthRatio: viewport.visibleArea.widthRatio
        heightRatio: viewport.visibleArea.heightRatio
        xPosition: viewport.visibleArea.xPosition
        yPosition: viewport.visibleArea.yPosition

        autoHide: true
    }
}
