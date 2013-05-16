import QtQuick 1.1

QtObject {
    property string section

    function log(level, args) {
        var esc = {
            warn: "\x1b[33m",
            info: "\x1b[36m",
            debug: "\x1b[34m",
            notice: "\x1b[0m",
            error: "\x1b[31m",
            end: "\x1b[0m"
        };

        var m = "";
        for (var i = 0; i < args.length; ++i)
            m += args[i] + " ";

        console.log(esc[level]+section+esc.end, m);
    }

    function debug() {
        log("debug", arguments);
    }

    function info() {
        log("info", arguments);
    }

    function notice() {
        log("notice", arguments);
    }

    function warn() {
        log("warn", arguments);
    }

    function error() {
        log("error", arguments);
    }
}
