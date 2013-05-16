import QtQuick 1.1
import fqw.page 1.0
import fqw.control 1.0
import fqw.controller 1.0
import fqw.indicator 1.0
import fqw.util 1.0

import "../../../cpi/cplay.js" as Cplay

Page {
    id: self

    objectName: title

    title: "Categories"

    property int screen_size_width: 1280
    property int screen_size_height: 720
    width: screen_size_width
    height: screen_size_height

    property int real_film_width: 169
    property int real_film_height: 226

    // 10%
    property int film_width: parent.width
    property int film_height: 150
    property int film_columns: 1
    property int film_rows: 999
    property int film_margin: 4
    property int fiche_width: film_width + 2 * film_margin
    property int fiche_height: film_height + 2 * film_margin


    ListModel {
        id: list_of_items
        ListElement { name: "Cinéma" }
        ListElement { name: "Séries" }
        ListElement { name: "Kids" }
        ListElement { name: "Vue récemment" }
        ListElement { name: "Playlist" }
        ListElement { name: "Adulte" }
    }

    ListModel {
        id: list_of_categories
        ListElement { name: "Action" }
        ListElement { name: "Fantastique" }
        ListElement { name: "Aventure" }
        ListElement { name: "Comedie" }
        ListElement { name: "Crime" }
        ListElement { name: "Thriller" }
        ListElement { name: "Romance" }
        ListElement { name: "Cinema érotique" }
        ListElement { name: "Classique" }
        ListElement { name: "Culte" }
        ListElement { name: "Drame" }
        ListElement { name: "Indépendant" }
        ListElement { name: "Horreur" }
        ListElement { name: "British" }
    }

    ListModel {
        id: list_of_films
    }

    ListModel {
        id: list_of_menus
    }

    ListModel {
        id: list_vide
    }

    Component {
        id: fiche
        Item {
            state: "s1"
            width: fiche_width
            height: fiche_height
            focus: false
            Flipable {
                id: flipable
                property bool flipped: false
                anchors.centerIn: parent
                width: film_width
                height: film_height
                front: Image { source: Cplay.displayImage("file.png") ; anchors.fill: parent ; opacity: 0.8 }
                back: Image {
                    id: dark_poster
                    source: icon
                    anchors.fill: parent
                    onStatusChanged: if (dark_poster.status == Image.Ready) flipable.flipped = true;
                }
                transform: Rotation {
                    id: rotation
                    origin.x: flipable.width/2
                    origin.y: flipable.height/2
                    axis.x: 1; axis.y: 0; axis.z: 0     // set axis.y to 1 to rotate around y-axis
                    angle: 0
                }
                states: State {
                    name: "back"
                    PropertyChanges { target: rotation; angle: 180 }
                    when: flipable.flipped
                }
                transitions: Transition {
                    NumberAnimation { target: rotation; property: "angle"; duration: 500 }
                }
            }
        }
    }
    
    Component {
        id: fiche_highlight
        Rectangle {
            width: film_width
            height: film_height
            color: "transparent"
            border.width: film_margin
            border.color: if (fiches_contener.focus == true) { "#008fdc" } else { "transparent" }
        }
    }

    Component {
        id: menu_item
        Rectangle {
            width: parent.parent.width
            height: 60
            color: "transparent"
            Text {
                anchors.centerIn: parent
                // text: name
                color: "white"
                font.pointSize: 18
                font.bold: true
            }
        }
    }

    Component {
        id: menu_highlight
        Rectangle {
            width: 150
            height: 150
            color: "transparent"
            border.width: 4
            border.color: if (menu_contener.focus == true) { "#008fdc" } else { "transparent" }
        }
    }


    Component {
        id: fiche_action_item
        Image {
            width: 102
            height: 107
            source: icon
        }
    }

    Component {
        id: fiche_action_highlight
        Rectangle {
            width: 102
            height: 107
            color: "transparent"
            border.width: 4 ; border.color: "#008fdc"
        }
    }

    Component {
        id: fiche_aussi_highlight
        Rectangle {
            width: film_width
            height: film_height
            color: "transparent"
            border.width: film_margin
            border.color: "#008fdc"
        }
    }

    FocusShower {
        id: fs
        anchors.fill: parent
        Rectangle {
            id: menu_contener
            state: "m1"
            width: parent.parent.width
            height: parent.parent.height
            anchors.top: parent.top
            color: "transparent"
            GridView {
                width: parent.width
                // anchors.rightMargin: 40
                height: parent.height
                highlight: menu_highlight
                model: list_of_menus
                delegate: menu_item
                flow: GridView.TopToBottom
                clip: false
                keyNavigationWraps: false
            }
        }
        Keys.onLeftPressed: popButton.clicked()
    }

    property alias keyPresses: fs.keyPresses
    property real ratio: .5

    persistentProperties: ["keyPresses"]

    property Item companionView: FocusScope {
        id: cv
        anchors.fill: parent
        focus: false
        property real ratio: (1 - self.ratio)

        FocusShower {
            id: illustrations
            anchors.fill: parent
            Rectangle {
                width: parent.width
                height: parent.height
                anchors.top: parent.top
                color: "black"
                Item {
                    id: fiches_contener
                    // anchors.top: menu_contener.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: fiche_width * film_columns
                    height: fiche_height * film_rows

                    GridView {
                        id: fiches
                        anchors.fill: parent
                        cellWidth: fiche_width
                        cellHeight: fiche_height
                        highlight: fiche_highlight
                        model: list_of_films
                        delegate: fiche
                        clip: true
                        flow: GridView.TopToBottom
                        keyNavigationWraps: false
                    }
                }
            }
            Item {
                id: fiche_contener
                anchors.fill: parent
                property string poster: "img/file.png"
                Rectangle {
                    color: "black"
                    id: fiche_contener_bg
                    anchors.fill: parent
                    opacity: 0
                    Rectangle {
                        id: fiche_header
                        width: 1280
                        height: 60
                        anchors.top: parent.top
                        anchors.left: parent.left
                        color: "transparent"
                    }
                }
            }
        }
    }
    Component.onCompleted: Cplay.main()
    Keys.onPressed: Cplay.nav_onPressed(event)
}
