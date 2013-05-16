include(config)

TEMPLATE = subdirs
CONFIG += ordered
SUBDIRS = src

!isEmpty(CONFIG_TEST)		{ SUBDIRS += test }
