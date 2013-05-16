import QtQuick 1.1

Image {
    id: widget;

    property string background: "";
    property string logo: "";
    property real logoRatio: .8

    asynchronous: true;
    anchors.fill: parent;
    smooth: true;
    source: "background/" + widget.background + ".png"

    Image {
        visible: widget.logo != "";
        anchors {
            centerIn: parent;
        }
        width: Math.min(widget.width, widget.height) * widget.logoRatio
        height: Math.min(widget.width, widget.height) * widget.logoRatio
        fillMode: Image.PreserveAspectFit
        smooth: true;
        asynchronous: true;
        source: widget.logo ? "logo/" + widget.logo + ".png" : ""
    }
}
