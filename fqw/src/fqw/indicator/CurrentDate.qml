import QtQuick 1.1
import fqw.util 1.0

Text {
    id: self

    property alias format: date.format

    Date {
        id: date
    }

    text: date.date;
    font.pixelSize: height * .8
}
