
TEMPLATE = subdirs

QML_FILES += qmldir \
Background.qml   \
CurrentTime.qml  \
CurrentDate.qml  \
FocusShower.qml  \
InfoPanel.qml    \
Loading.qml      \
Label.qml \
PlayerStatus.qml \
ProgressBar.qml  \
FramedImage.qml  \
Scrollbar.qml    \
ServerClock.qml  \
TimeLine.qml

SUBDIRS = loading player logo background

include(../../../fqw-qml.pri)
