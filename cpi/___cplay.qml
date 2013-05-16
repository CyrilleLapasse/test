import QtQuick 1.1
import fqw.application 1.0
import fqw.control 1.0
import fqw.controller 1.0
import fqw.indicator 1.0
import fqw.util 1.0

import "cplay.js" as Cplay


//Application {
Rectangle {
	id: cplay
	//title: "CanalPlay"
	scale: 1
	property int screen_size_width: 1280
	property int screen_size_height: 720
	width: screen_size_width
	height: screen_size_height
	color: "black"

	property int real_film_width: 169
	property int real_film_height: 226

	// 10%
	property int film_width: 152
	property int film_height: 202
	property int film_columns: 7
	property int film_rows: 3
	property int film_margin: 4

	// 20%
/*
	property int film_width: 135
	property int film_height: 180
	property int film_columns: 7
	property int film_rows: 3
	property int film_margin: 4
*/

	property int menu_width: 200
	property int menu_height: 40


	property int fiche_width: film_width + 2 * film_margin
	property int fiche_height: film_height + 2 * film_margin

	ListModel {
		id: list_of_films
	}

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
		id: list_vide
	}

	ListModel {
		id: list_of_actions
		ListElement { icon: "img/boutons_voir.png" }
		ListElement { icon: "img/boutons_ba.png" }
		ListElement { icon: "img/boutons_ajoutplaylist.png" }
		ListElement { icon: "img/boutons_jaime.png" }
		ListElement { icon: "img/boutons_ficheinfo.png" }
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
				front: Image { source: "img/file.png" ; anchors.fill: parent ; opacity: 0.8 }
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
			width: menu_width
			height: menu_height
			color: "transparent"
			Text {
				anchors.centerIn: parent
				text: name
				color: "white"
				font.pointSize: 18
				font.bold: true
			}
		}
	}

	Component {
		id: menu_highlight
		Rectangle {
			width: menu_width
			height: menu_height
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




	Rectangle {
		//background: "text"
		color: "black"
		width: 1280
		height: 720

		Rectangle {
			id: menu_contener
			state: "m1"
			width: 1280
			height: 60
			anchors.top: parent.top
			color: "transparent"
			Image {
				source: "img/logocanalplay.png"
				anchors.verticalCenter: menu_contener.verticalCenter
				anchors.left: parent.left
				anchors.leftMargin: 40
			}
			Rectangle {
				id: menu1_bg
				width: menu_width*5 + 40
				height: 0
				color: "transparent"
				anchors.bottom: parent.bottom
				anchors.right: parent.right
				anchors.rightMargin: 20
				Image {
					anchors.left: parent.left
					anchors.verticalCenter: parent.verticalCenter
					source: "img/prev.png";
					width: 20
					height: (parent.height < 25) ? parent.height : 25
					opacity: (menu1.currentIndex > 0) ? 1 : 0
				}
				GridView {
					id: menu1
					anchors.bottom: parent.bottom
					anchors.right: parent.right
					anchors.rightMargin: 40
					width: menu_width*5
					height: parent.height
					cellWidth: menu_width
					cellHeight: menu_height
					highlight: menu_highlight
					model: list_of_items
					delegate: menu_item
					flow: GridView.TopToBottom
					clip: true
					keyNavigationWraps: false
					Behavior on height { NumberAnimation { duration: 200 } }
				}
				Image {
					anchors.right: parent.right
					anchors.verticalCenter: parent.verticalCenter
					source: "img/next.png";
					width: 20
					height: (parent.height < 25) ? parent.height : 25
					opacity: (menu1.currentIndex < 5) ? 1 : 0
				}
			}
			Rectangle {
				id: menu2_bg
				width: menu_width*5 + 40
				height: 0
				color: "transparent"
				anchors.bottom: parent.bottom
				anchors.right: parent.right
				anchors.rightMargin: 20
				Image {
					anchors.left: parent.left
					anchors.verticalCenter: parent.verticalCenter
					source: "img/prev.png";
					width: 20
					height: (parent.height < 25) ? parent.height : 25
					opacity: (menu2.currentIndex > 0) ? 1 : 0
				}
				GridView {
					id: menu2
					anchors.bottom: parent.bottom
					anchors.right: parent.right
					anchors.rightMargin: 40
					width: menu_width*5
					height: parent.height
					cellWidth: menu_width
					cellHeight: menu_height
					highlight: menu_highlight
					model: list_of_categories
					delegate: menu_item
					flow: GridView.TopToBottom
					clip: true
					keyNavigationWraps: false
					Behavior on height { NumberAnimation { duration: 200 } }
				}
				Image {
					anchors.right: parent.right
					anchors.verticalCenter: parent.verticalCenter
					source: "img/next.png";
					width: 20
					height: (parent.height < 25) ? parent.height : 25
					opacity: (menu2.currentIndex < 13) ? 1 : 0
				}
			}
			GridView {
				id: menu3
				anchors.bottom: parent.bottom
				anchors.right: parent.right
				anchors.rightMargin: 40
				width: menu_width*5
				height: 0
				cellWidth: menu_width
				cellHeight: menu_height
				highlight: menu_highlight
				model: list_vide
				delegate: menu_item
				flow: GridView.TopToBottom
				clip: true
				keyNavigationWraps: false
				Behavior on height { NumberAnimation { duration: 200 } }
			}
			states: [
				State {
					name: "m1"
					PropertyChanges { target: menu1_bg ; height: menu_height }
					PropertyChanges { target: menu2_bg ; height: 0 }
					PropertyChanges { target: menu3 ; height: 0 }
				},
				State {
					name: "m2"
					PropertyChanges { target: menu1_bg ; height: 0 }
					PropertyChanges { target: menu2_bg ; height: menu_height }
					PropertyChanges { target: menu3 ; height: 0 }
				},
				State {
					name: "m3"
					PropertyChanges { target: menu1_bg ; height: 0 }
					PropertyChanges { target: menu2_bg ; height: 0 }
					PropertyChanges { target: menu3 ; height: menu_height }
				}
			]
			Keys.onPressed: Cplay.menu_onPressed(event)
		}


		Item {
			id: fiches_contener
			anchors.top: menu_contener.bottom
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
			focus: true
			Keys.onPressed: Cplay.fiches_onPressed(event)
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
					Image {
						source: "img/logocanalplay.png"
						anchors.verticalCenter: parent.verticalCenter
						anchors.left: parent.left
						anchors.leftMargin: 40
					}
/*
					Text {
						anchors.centerIn: parent
						horizontalAlignment: Text.AlignHCenter
						verticalAlignment: Text.AlignVCenter
						text: "Retour à la liste"
						font.pointSize: 14
						font.weight: Font.Bold
						color: "white"
					}
*/
					Image {
						anchors.centerIn: parent
						source: "img/up.png"
						width: 25
						height: 20
					}
				}
				Image {
					id: fiche_poster
					anchors.top: fiche_header.bottom
					anchors.left: parent.left
					anchors.leftMargin: 16
					source: parent.parent.poster
					width: real_film_width*1.6
					height: real_film_height*1.6
				}
				Text {
					id: fiche_title
					anchors.top: fiche_header.bottom
					anchors.left: fiche_poster.right
					anchors.right: parent.right
					anchors.leftMargin: 16
					anchors.rightMargin: 16
					text: "LA VÉRITABLE HISTOIRE DU PETIT CHAPERON ROUGE"
					horizontalAlignment: Text.AlignLeft
					verticalAlignment: Text.AlignBottom
					font.pointSize: 24
					font.weight: Font.Bold
					wrapMode: Text.Wrap
					color: "white"
				}
				Text {
					id: fiche_info
					anchors.top: fiche_title.bottom
					anchors.left: fiche_poster.right
					anchors.leftMargin: 16
					anchors.right: fiche_contener_bg.right
					anchors.rightMargin: 16
					text: ""
					horizontalAlignment: Text.AlignLeft
					verticalAlignment: Text.AlignBottom
					font.pointSize: 16
					font.weight: Font.Bold
					wrapMode: Text.Wrap
					color: "grey"
				}
				Text {
					id: fiche_accroche
					anchors.top: fiche_info.bottom
					anchors.left: fiche_poster.right
					anchors.leftMargin: 16
					anchors.right: fiche_contener_bg.right
					anchors.rightMargin: 16
					text: "<p>De : <br>Avec : <p>Une petite fille avec capuche rouge, un loup, une mère-grand, une chevillette, une bobinette, un panier avec une galette...<br>Vous pensez connaître cette histoire ?<br>Une petite fille avec capuche rouge, un loup, une mère-grand, une chevillette, une bobinette, un panier avec une galette..."
					horizontalAlignment: Text.AlignLeft
					verticalAlignment: Text.AlignBottom
					font.pointSize: 14
					font.weight: Font.Bold
					wrapMode: Text.Wrap
					color: "white"
				}
				Rectangle {
					id: fiche_action_bg
					anchors.horizontalCenter: parent.horizontalCenter
					y: 720-107-20-32
					width: fiche_width*6 + 2*20
					height: 107+20
					color: "transparent"

					GridView {
						id: fiche_action
						anchors.horizontalCenter: parent.horizontalCenter
						anchors.top: parent.top
						anchors.bottomMargin: 32
						width: 102*5
						height: (parent.height < 107) ? parent.height : 107
						cellWidth: 102
						cellHeight: 107
						highlight: fiche_action_highlight
						model: list_of_actions
						delegate: fiche_action_item
						flow: GridView.TopToBottom
						keyNavigationWraps: false
						clip: true
						Behavior on height { NumberAnimation { duration: 200 } }
						Keys.onPressed: Cplay.logMe()
					}
					Image {
						anchors.horizontalCenter: parent.horizontalCenter
						anchors.bottom: parent.bottom
						source: "img/down.png";
						width: 25
						height: (parent.height < 20) ? parent.height : 20
						Behavior on height { NumberAnimation { duration: 200 } }
					}
				}
				Rectangle {
					id: fiche_aussi_bg
					anchors.horizontalCenter: parent.horizontalCenter
					anchors.bottom: parent.bottom
					anchors.bottomMargin: 32
					width: fiche_width*6 + 2*20
					height: 0
					color: "transparent"

					Image {
						anchors.horizontalCenter: parent.horizontalCenter
						anchors.top: parent.top
						source: "img/up.png";
						width: 25
						height: (parent.height < 20) ? parent.height : 20
						Behavior on height { NumberAnimation { duration: 200 } }
					}
					Image {
						anchors.left: parent.left
						anchors.verticalCenter: parent.verticalCenter
						source: "img/prev.png";
						width: 20
						height: (parent.height < 25) ? parent.height : 25
						opacity: (fiche_aussi.currentIndex > 0) ? 1 : 0
						Behavior on height { NumberAnimation { duration: 200 } }
						Behavior on opacity { NumberAnimation { duration: 200 } }
					}
					GridView {
						id: fiche_aussi
						anchors.horizontalCenter: parent.horizontalCenter
						anchors.bottom: parent.bottom
						width: fiche_width*6
						height: (parent.height < fiche_height) ? parent.height : fiche_height
						cellWidth: fiche_width
						cellHeight: fiche_height
						highlight: fiche_aussi_highlight
						model: list_of_films
						delegate: fiche
						flow: GridView.TopToBottom
						keyNavigationWraps: false
						clip: true
						Behavior on height { NumberAnimation { duration: 200 } }
					}
					Image {
						anchors.right: parent.right
						anchors.verticalCenter: parent.verticalCenter
						source: "img/next.png";
						width: 20
						height: (parent.height < 25) ? parent.height : 25
						opacity: (fiche_aussi.currentIndex < 48) ? 1 : 0
						Behavior on height { NumberAnimation { duration: 200 } }
						Behavior on opacity { NumberAnimation { duration: 200 } }
					}
					Keys.onPressed: Cplay.fiches_onPressed(event)
					Behavior on opacity { NumberAnimation { duration: 200 } }
				}
				Behavior on opacity { NumberAnimation { duration: 200 } }
			}
			states: [
				State {
					name: "s1"
					PropertyChanges { target: fiche_contener_bg ; opacity: 0 }
					PropertyChanges { target: fiche_action_bg ; height: 107+20 }
					PropertyChanges { target: fiche_aussi_bg ; height: 0 }
				},
				State {
					name: "s2"
					PropertyChanges { target: fiche_contener_bg ; opacity: 1 }
					PropertyChanges { target: fiche_action_bg ; height: 107+20 }
					PropertyChanges { target: fiche_aussi_bg ; height: 0 }
				},
				State {
					name: "s3"
					PropertyChanges { target: fiche_contener_bg ; opacity: 1 }
					PropertyChanges { target: fiche_action_bg ; height: 0 }
					PropertyChanges { target: fiche_aussi_bg ; height: fiche_height+20 }
				}
			]
			Keys.onPressed: Cplay.fiche_onPressed(event)
		}
		

	}

	Component.onCompleted: Cplay.main()
}
