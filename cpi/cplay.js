//var baseref = "http://qml.rnd.hubee.tv/films/";
var baseref = "../../../cpi/";
var top_menus = {0:'Categories',1:'Sous categories',2:'Une autre sous categorie'};

function getMenu(depht) {
	return depht in top_menus ? top_menus[depht] : 'Profondeur non referencee ' + depht;
}

function loadData(data_type, depht) {
	var rq = new XMLHttpRequest();
	depht = depht ? (parseInt(depht)-1).toString() : '';
	rq.onreadystatechange = function () {
		if (rq.readyState != rq.DONE) {
			return false;
		}
		if (rq.status >= 300) {
			console.log("XMLHttpRequest error " + rq.status);
			return false;
		}
		if(!rq.responseText) {
			return false;
		}
		if(data_type == 'films') {
			var films = JSON.parse(rq.responseText);
			for (var i = 0; i < films.length; i++) {
				list_of_films.append({
					"title": films[i].title,
					"icon": baseref + "films/" + films[i].id + ".jpg",
					"description": (films[i].description || {})
				});
			}
		} else {
			var menus = JSON.parse(rq.responseText);
			for (var i = 0; i < menus.length; i++) {
				list_of_menus.append({
					"name": menus[i].title,
					"icon": baseref + "menus/" + menus[i].id + ".jpg"
				});
			}

		}
	}
	rq.open("GET", baseref + data_type + "/" + data_type + depht + ".json");
	rq.send();

	return true;
}


function main() {
	loadData('films');
	loadData('menus', stack.depth);
}


function nav_onPressed(event)
{
	console.log(fs.activeFocus, fiches.activeFocus, fiches_contener.activeFocus);
	switch (event.key) {
		case Qt.Key_Up:
			if(fiches_contener.activeFocus)
				fiches_contener.moveCurrentIndexUp();
			else {
				return true;
			}
			return true;

		case Qt.Key_Down:
			if(fiches_contener.activeFocus) {
				fiches_contener.moveCurrentIndexDown();
			}
			else
				return true;
			return true;

		case Qt.Key_Left:
			if(fs.activeFocus) {
				popButton.clicked();
				console.log('popButton');
			} else {
				fiches_contener.focus = false;
				fs.focus = true;
			}
			return true;

		case Qt.Key_Right:
			if(fs.activeFocus) {
				fiches_contener.focus = true;
				fs.focus = false;
			} else {
				console.log('pushButton');
				pushButton.clicked();
			}
			return true;

		case Qt.Key_Return:
			if (fiche_contener.state == "s2") {
				fiche_doAction(event);
				console.log('Action depuis fiche film!');
			}
			else {
				console.log(fiches_contener.title);
				stack.replace("page0.qml", { title: "Film " + (stack.depth - 1), ratio: .3 + ((stack.depth - 1) % 5) / 10. });
				console.log(page.title);
				return true;
				var i = list_of_films.get(fiches.currentIndex);
				fiche_contener.poster = i.icon;
				fiche_title.text = (i.title.charAt(0).toUpperCase() + i.title.substr(1)).replace(RegExp('[\ _-]', 'g'), ' ');
				fiche_info.text = '<p>' + (i.info || 'no info') + '<br />';
				fiche_accroche.text = 'De : '
					+ (i.description['author'] || 'no author')
					+ '<br />Avec : ' + (i.description['participants'] || 'no participants')
					+ '<br />' + (i.description['text'] || 'no text')
					+ '</p>';
				fiche_contener.state = "s2";
				fiche_contener.focus = true;
			}

		return true;
	}
}


function fiches_onPressed(event)
{
	var stocked_previousIndex = fiches.currentIndex;
	var nb_lines = Math.floor(fiches.parent.height / fiches.cellHeight); // Calcul du nombre de lignes a l'ecran
	var define_line = fiches.currentIndex / nb_lines;
	define_line = define_line.toString();
	define_line = define_line.indexOf('.') != '-1' ? define_line.substring(define_line.indexOf('.')+1, define_line.indexOf('.')+2) : 0;

	switch (event.key) {
	case Qt.Key_Left:
		fiches.moveCurrentIndexLeft();
		if(fiches.currentIndex == stocked_previousIndex) { // Si on arrive au bout de la ligne...
			fiches.moveCurrentIndexUp();
			fiches.currentIndex = fiches.currentIndex > 0 ? (fiches.count - 1) - fiches.currentIndex : 0;
		}
		break
	case Qt.Key_Right:
		fiches.moveCurrentIndexRight();

		if(fiches.currentIndex == stocked_previousIndex) { // Si on arrive au bout de la ligne...
			fiches.moveCurrentIndexDown();
			fiches.currentIndex = (fiches.count) - fiches.currentIndex;
		}
		break;
	case Qt.Key_Up:
		var y = fiches.currentIndex % cplay.film_rows;
		if (y == 0) {
			menu_contener.focus = true;
		}
		else
			fiches.moveCurrentIndexUp();
		break;
	case Qt.Key_Down:
		fiches.moveCurrentIndexDown();
		return true;
	case Qt.Key_Return:
		var i = list_of_films.get(fiches.currentIndex);
		fiche_contener.poster = i.icon;
		fiche_title.text = (i.title.charAt(0).toUpperCase() + i.title.substr(1)).replace(RegExp('[\ _-]', 'g'), ' ');
		fiche_info.text = '<p>' + (i.info || 'no info') + '<br />';
		fiche_accroche.text = 'De : '
			+ (i.description['author'] || 'no author')
			+ '<br />Avec : ' + (i.description['participants'] || 'no participants')
			+ '<br />' + (i.description['text'] || 'no text')
			+ '</p>';
		fiche_action.currentIndex = 0;
		fiche_aussi.currentIndex = 0;
		fiche_contener.state = "s2";
		fiche_contener.focus = true;
		break;
	default:
		break;
	}
	return true;
}


function menu_onPressed(event)
{
	console.log("menu_onPressed state: "+menu_contener.state);
	switch (event.key) {
	case Qt.Key_Left:
		switch (menu_contener.state) {
		case "m1":
			return menu1.moveCurrentIndexLeft();
		case "m2":
			return menu2.moveCurrentIndexLeft();
		default:
			return true;
		}
		break;

	case Qt.Key_Right:
		switch (menu_contener.state) {
		case "m1":
			return menu1.moveCurrentIndexRight();
		case "m2":
			return menu2.moveCurrentIndexRight();
		default:
			return true;
		}
		break;

	case Qt.Key_Up:
		switch (menu_contener.state) {
		case "m2":
			menu_contener.state = "m1";
			return true;
		case "m3":
			menu_contener.state = "m2";
			return true;
		default:
			return false;
		}
		break;

	case Qt.Key_Down:
		fiches_contener.focus = true;
		return true;

	case Qt.Key_Return:
		switch (menu_contener.state) {
		case "m1":
			menu2.currentIndex = 0;
			menu2.positionViewAtBeginning();
			menu_contener.state = "m2";
			return true;
		case "m2":
			console.log("select "+ menu2.currentIndex + " " + list_of_categories.get([menu2.currentIndex]).name);
			list_of_films.clear();
			list_vide.clear();
			loadData('films');
			list_vide.append({ name: list_of_categories.get([menu2.currentIndex]).name });
			menu_contener.state = "m3";
			fiches_contener.focus = true;
			return true;
		default:
			return false;
		}
		break;
	default:
		return false;
	}
}

function fiche_doAction(event) {
	var video_id = video_id || list_of_actions.currentIndex;
}

function displayImage(filename) {
	return baseref + "img/" + filename;
}

function shout(something) { 
	console.log( (something ? something : 'Boo!') );
}

function doFocus(_bool, _object_id) {
	return _object_id.focus == _bool;
}