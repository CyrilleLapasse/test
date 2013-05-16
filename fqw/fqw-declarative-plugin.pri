include(fqw.pri)

PLUGINPATH	?= $$PLUGIN

TARGET		= $${PLUGIN}plugin
TARGETPATH	= $$[QT_INSTALL_IMPORTS]/fqw/$$PLUGINPATH

TEMPLATE	= lib
CONFIG		+= plugin
QT		+= declarative

target.path	= $$TARGETPATH

qmldir.files	= qmldir
qmldir.path	= $$TARGETPATH

INSTALLS	+= target qmldir
