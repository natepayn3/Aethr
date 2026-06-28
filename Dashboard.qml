import QtQuick

Item {
    id: dashboardRoot
    anchors.fill: parent

    // Configuration inherited or explicitly specified
    readonly property color textSoftWhite: "#f5f5f5"

    Text {
        anchors.centerIn: parent
        text: "Dashboard Content View"
        color: dashboardRoot.textSoftWhite
        font.pixelSize: 16
    }
}