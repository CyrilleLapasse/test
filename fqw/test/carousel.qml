import QtQuick 1.1
import fqw.controller 1.0

Rectangle {
    width: 800
    height: 600
    color: "gray"

    ListModel {
        id: model

        ListElement {
            url: "channel_351_screenshot_1_533x300.jpg"
        }
        ListElement {
            url: "channel_351_screenshot_2_533x300.jpg"
            label: "with_label"
        }
        ListElement {
            url: "channel_351_screenshot_3_533x300.jpg"
            label: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt."
        }
    }

    Carousel {
        anchors.fill: parent
        baseUrl: Qt.resolvedUrl("images/")
        model: model
        focus: true
    }
}
