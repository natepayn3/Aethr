import QtQuick

QtObject {
    id: config

    // --- SYSTEM THEME MATRIX ---
    property color themeBackground: Qt.rgba(0.4, 0.4, 0.4, 1.00)
    property color colorBackground: Qt.rgba(0.4, 0.4, 0.4, 0.3) // increase last number to make windows more visible
    property color colorBorder: Qt.rgba(1, 1, 1, 0.05)
    property color hoverBorder: Qt.rgba(0, 0, 0, 0.2)
    property color themeBorder: Qt.rgba(0, 0, 0, 0.15)
    property color cardBorder: Qt.rgba(0, 0, 0, 0.2)
    property color themeText: "#FFFFFF"
    property color themeAccent: Qt.rgba(0.4, 0.4, 0.4, 0.28)
    property color colorAccent: Qt.rgba(0.6, 0.45, 0.9, 1.0)
    
    property string shellFont: "Google Sans Flex"
    property int radiusValue: 16
    
    // --- GLOBAL LAYOUT GEOMETRY ---
    property int panelWidth: 360
    property int launcherWidth: 500
    property int panelBottomMargin: 100

    // --- UNIFORM ANIMATION METRICS ---
    property int durationIn: 400
    property int durationOut: 200
    property int opacityIn: 200
    property int opacityOut: 150
    property real springBack: 2.5
    property real springIn: 1.5
}
