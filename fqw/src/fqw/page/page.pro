
TEMPLATE = subdirs

QML_FILES += qmldir \
Page.qml \
Frame.qml \
Explorer.qml \
Container.qml \
Breadcrumb.qml \
Tabs.qml \
Stack.qml

SUBDIRS = breadcrumb

include(../../../fqw-qml.pri)
