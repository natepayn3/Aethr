import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: dockWindow
    
    // Links back to the AppLauncher instance declared in the root layout
    required property var launcherModule

    // --- STYLING COEFFICIENTS ---
    property color themeBackground: Qt.rgba(0.08, 0.08, 0.08, 0.9) 
    property color themeText: "#ffffff"
    property color themeAccent: Qt.rgba(1, 1, 1, 0.15) 
    property color themeBorder: Qt.rgba(1, 1, 1, 0.05)

    anchors {
        bottom: true
        left: true
        right: true
    }
    
    implicitHeight: 65
    color: "transparent"
    exclusiveZone: 0

    // Clickthrough Mask: Isolates input interception to the physical dock frame bounds
    mask: Region {
        item: masterContainer
    }

    Item {
        id: masterContainer
        width: 240
        height: parent.height
        anchors.horizontalCenter: parent.horizontalCenter

        // Edge tracking vector for cursor proximity detection
        MouseArea {
            id: hotspotTrigger
            width: 220
            height: 12
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            hoverEnabled: true
        }

        // --- INTERACTIVE DOCK HITBOX ---
        MouseArea {
            id: dockHitbox
            width: visualDock.width + 20 
            height: 60
            anchors.horizontalCenter: parent.horizontalCenter
            hoverEnabled: true

            property bool isPinned: hotspotTrigger.containsMouse ||
                                    dockHitbox.containsMouse || 
                                    dockWindow.launcherModule.launcherWindowObject.visible

            anchors.bottom: parent.bottom
            anchors.bottomMargin: isPinned ? 6 : -65

            Behavior on anchors.bottomMargin {
                NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
            }

            Row {
                id: visualDock
                spacing: 12
                anchors.centerIn: parent 

                // --- BUTTON 1: APP LAUNCHER ---
                Rectangle {
                    id: btnLauncher
                    width: 55
                    height: 55
                    radius: 12
                    color: mouseLauncher.containsMouse ? dockWindow.themeAccent : dockWindow.themeBorder
                    Behavior on color { ColorAnimation { duration: 150 } }

                    Text {
                        anchors.centerIn: parent
                        text: "apps"
                        font.family: "Material Symbols Outlined"
                        font.pixelSize: 26
                        color: dockHitbox.isPinned ? Qt.rgba(dockWindow.themeText.r, dockWindow.themeText.g, dockWindow.themeText.b, 0.85) : Qt.rgba(1, 1, 1, 0.0)
                        Behavior on color { ColorAnimation { duration: 180 } }
                    }

                    MouseArea {
                        id: mouseLauncher
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: dockWindow.launcherModule.active = !dockWindow.launcherModule.active
                    }
                }

                // --- BUTTON 2: WALLPAPER PICKER (STUB) ---
                Rectangle {
                    id: btnWallpaper
                    width: 55
                    height: 55
                    radius: 12
                    color: mouseWallpaper.containsMouse ? dockWindow.themeAccent : dockWindow.themeBorder
                    Behavior on color { ColorAnimation { duration: 150 } }

                    Text {
                        anchors.centerIn: parent
                        text: "wallpaper"
                        font.family: "Material Symbols Outlined"
                        font.pixelSize: 26
                        color: dockHitbox.isPinned ? Qt.rgba(dockWindow.themeText.r, dockWindow.themeText.g, dockWindow.themeText.b, 0.85) : Qt.rgba(1, 1, 1, 0.0)
                        Behavior on color { ColorAnimation { duration: 180 } }
                    }

                    MouseArea {
                        id: mouseWallpaper
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: console.log("Wallpaper Picker Action Triggered")
                    }
                }

                // --- BUTTON 3: SCREENSHOT UTILITY (STUB) ---
                Rectangle {
                    id: btnScreenshot
                    width: 55
                    height: 55
                    radius: 12
                    color: mouseScreenshot.containsMouse ? dockWindow.themeAccent : dockWindow.themeBorder
                    Behavior on color { ColorAnimation { duration: 150 } }

                    Text {
                        anchors.centerIn: parent
                        text: "screenshot_region"
                        font.family: "Material Symbols Outlined"
                        font.pixelSize: 26
                        color: dockHitbox.isPinned ? Qt.rgba(dockWindow.themeText.r, dockWindow.themeText.g, dockWindow.themeText.b, 0.85) : Qt.rgba(1, 1, 1, 0.0)
                        Behavior on color { ColorAnimation { duration: 180 } }
                    }

                    MouseArea {
                        id: mouseScreenshot
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: console.log("Screenshot Tool Action Triggered")
                    }
                }
            }
        }
    }
}