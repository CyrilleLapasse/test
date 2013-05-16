import QtQuick 1.1

QtObject {
    id: self

    property int interval: (format.indexOf("s") >= 0) ? 1000 : 60000

    property int hours
    property int minutes
    property int seconds

    property string format: "hh:mm"
    property string time

    property QtObject t: Timer {
        id: timer
        interval: scheduleNext()
        running: true;
        repeat: true;
        onTriggered: {
            self.updateTime();
            interval = scheduleNext();
        }
    }

    function updateTime()
    {
        var d = new Date();

        self.hours = d.getHours();
        self.minutes = d.getMinutes();
        self.seconds = d.getSeconds();
        self.time = Qt.formatTime(d, format);
    }

    function scheduleNext()
    {
        var d = new Date();

        var next = (self.interval
            - ((d.getSeconds() * 1000 + d.getMilliseconds()) % self.interval)
            + 50);

        if (next <= 100)
            next = 100;

        return next;
    }

    Component.onCompleted: updateTime()
}
