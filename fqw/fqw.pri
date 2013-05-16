
FQWPATH = fqw
FQWSRCPATH = $$PWD

unix {
    isEmpty(PREFIX) {
	PREFIX = /usr
    }

    BINDIR = $$PREFIX/bin
    LIBDIR = $$PREFIX/lib
    DATADIR = $$PREFIX/share

    DEFINES += DATADIR=\\\"$$DATADIR\\\"
}
