import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import Quickshell.Io

PanelWindow {
    id: systemDockWindow

    WlrLayershell.namespace: "quickshell-launcher"
    WlrLayershell.keyboardFocus: WlrLayershell.None

    // Using the native mask property to eliminate the background dead zone completely
    mask: dockHitbox.isPinned ? maskRegion : null

    Region {
        id: maskRegion
        item: visualColumnContainer
    }

    // --- SYSTEM THEME MATRIX ---
    property color themeText: "#ffffff"
    property color themeAccent: Qt.rgba(0.4, 0.4, 0.4, 0.28)
    property color hoverBorder: Qt.rgba(0, 0, 0, 0.2)

    anchors {
        right: true
    }
    
    implicitWidth: 120
    implicitHeight: visualColumnContainer.height + 32
    color: "transparent"
    exclusiveZone: 0

    Item {
        id: masterContainer
        anchors.fill: parent

        // Right-aligned invisible screen-edge strip to catch mouse entry
        MouseArea {
            id: hotspotTrigger
            width: 14
            height: parent.height - 16
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            hoverEnabled: true
        }

        MouseArea {
            id: dockHitbox
            anchors.fill: parent
            hoverEnabled: true

            property bool stableHover: hotspotTrigger.containsMouse || dockHitbox.containsMouse
            property bool isPinned: false

            onStableHoverChanged: {
                if (stableHover) {
                    dismissTimer.stop();
                    isPinned = true;
                } else {
                    dismissTimer.start();
                }
            }

            Rectangle {
                id: visualColumnContainer
                width: 104
                height: (visualColumn.children.length * 100) + ((visualColumn.children.length - 1) * 12) + 24
                radius: 16
                anchors.verticalCenter: parent.verticalCenter
                
                // Animates smoothly off-screen to the right side of the monitor
                anchors.right: parent.right
                anchors.rightMargin: dockHitbox.isPinned ? 5 : -120

                color: Qt.rgba(0, 0, 0, 0.01) 

                Behavior on anchors.rightMargin {
                    NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
                }

                Column {
                    id: visualColumn
                    spacing: 12
                    anchors.centerIn: parent

                    // --- CPU TELEMETRY NODE ---
                    Item {
                        width: 100
                        height: 100
                        ResourceRing { ringName: "CPU"; anchors.centerIn: parent }
                    }

                    // --- GPU TELEMETRY NODE ---
                    Item {
                        width: 100
                        height: 100
                        ResourceRing { ringName: "GPU"; anchors.centerIn: parent }
                    }

                    // --- RAM TELEMETRY NODE ---
                    Item {
                        width: 100
                        height: 100
                        ResourceRing { ringName: "RAM"; anchors.centerIn: parent }
                    }

                    // --- DISK TELEMETRY NODE ---
                    Item {
                        width: 100
                        height: 100
                        ResourceRing { ringName: "DISK"; anchors.centerIn: parent }
                    }
                }
            }
        }
    }

    Timer {
        id: dismissTimer
        interval: 500
        running: false
        repeat: false
        onTriggered: {
            dockHitbox.isPinned = false;
        }
    }
}