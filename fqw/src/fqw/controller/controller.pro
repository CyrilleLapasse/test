
TEMPLATE = subdirs

QML_FILES += qmldir \
ScrollableColumn.qml \
Carousel.qml \
DataExplorer.qml   \
DirectoryList.qml  \
ElementView.qml    \
JsonListLoader.js  \
JsonListLoader.qml \
TransitionManager.qml \
TransitionManager.js \
animation.js \
KeyFocusController.qml \
keyfocuscontroller.js

SUBDIRS = carousel

include(../../../fqw-qml.pri)
