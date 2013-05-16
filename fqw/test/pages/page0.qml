import QtQuick 1.1
import fqw.page 1.0
import fqw.indicator 1.0

Page {
    id: self

    objectName: title

    title: "Menu"

    FocusShower {
        anchors.fill: parent
        label: parent.title + "<br/>" + self.state
    }

	Component.onCompleted: console.log(self, "created")
	Component.onDestruction: console.log(self, "destroyed")

	onWillAppear: console.log(self, "will appear")
	onWillDisappear: console.log(self, "will disappear")
	onDidAppear: console.log(self, "did appear")
	onDidDisappear: console.log(self, "did disappear")

}
