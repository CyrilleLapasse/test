
TEMPLATE = subdirs
QML_FILES += qmldir \
Button.qml   \
Slider.qml   \
Switch.qml   \
Combo.qml   \
CheckBox.qml   \
TextArea.qml   \
TextInput.qml \
TabList.qml \
slider_cursor_blur.png  slider_cursor_focus.png  switch_no.png  switch_yes.png

SUBDIRS = checkbox radio switch slider
include(../../../fqw-qml.pri)
