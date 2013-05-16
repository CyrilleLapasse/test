include(fqw.pri)

OTHER_FILES += $$QML_FILES
TARGETPATH     = $${QMLPATH}/$$TARGET
qml_files.path = $$[QT_INSTALL_IMPORTS]/fqw/$$TARGETPATH
qml_files.files = $$OTHER_FILES

INSTALLS += qml_files
