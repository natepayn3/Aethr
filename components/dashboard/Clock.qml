import QtQuick
import "../../configs"

Column {
    id: clockRoot
    spacing: 2

    property date currentTime: new Date()

    Timer {
        interval: 1000
        running: clockRoot.visible
        repeat: true
        triggeredOnStart: true
        onTriggered: clockRoot.currentTime = new Date()
    }

    FontConfig { id: fc }

    Text {
        text: Qt.formatDateTime(clockRoot.currentTime, "h:mm ap")
        font.family: fc.mainFont
        font.pixelSize: 46
        font.weight: Font.Bold
        color: shellConfig.themeText
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
    }

    Text {
        text: Qt.formatDateTime(clockRoot.currentTime, "dddd • MMMM d")
        font.family: fc.mainFont
        font.pixelSize: 13
        font.weight: Font.Medium
        color: shellConfig.themeText
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
    }
}