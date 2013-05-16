
TEMPLATE = subdirs

SUBDIRS = std

QML_FILES += qmldir \
ClippedBar.qml    \
FocusToggler.qml  \
StandardAsset.qml

include(../../../fqw-qml.pri)
