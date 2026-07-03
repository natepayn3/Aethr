import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets

Row {
    id: taskbarRoot
    spacing: 16

    Repeater {
        model: Hyprland.toplevels.values

        delegate: Item {
            id: clientDelegate
            width: 64
            height: 64
            
            visible: modelData.monitor && (modelData.monitor.name === trayWindow.screen.name)

            property var desktopEntry: {
                let appId = (modelData.wayland && modelData.wayland.appId) ? modelData.wayland.appId : "";
                if (appId === "") return null;
                return DesktopEntries.heuristicLookup(appId);
            }

            Rectangle {
                anchors.fill: parent
                radius: 12
                color: (trayWindow.activeHoverIndex === index + 100) ? (trayWindow.themeAccent || "transparent") : "transparent"
                border.color: (trayWindow.activeHoverIndex === index + 100) ? (trayWindow.hoverBorder || "transparent") : "transparent"
                border.width: 1
                Behavior on color { ColorAnimation { duration: 150 } }
            }

            Item {
                id: iconContainer
                anchors.centerIn: parent
                width: modelData.activated ? 48 : 32
                height: modelData.activated ? 48 : 32
                
                Behavior on width { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
                Behavior on height { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }

                IconImage {
                    id: clientIcon
                    anchors.fill: parent
                    asynchronous: true
                    
                    source: {
                        let rawId = (modelData.wayland && modelData.wayland.appId) ? modelData.wayland.appId : "";
                        if (!rawId) return "";

                        if (desktopEntry && desktopEntry.icon) {
                            let xdgPath = Quickshell.iconPath(desktopEntry.icon, true);
                            if (xdgPath) return xdgPath;
                        }

                        let rawPath = Quickshell.iconPath(rawId, true);
                        if (rawPath) return rawPath;

                        let lowerPath = Quickshell.iconPath(rawId.toLowerCase(), true);
                        if (lowerPath) return lowerPath;

                        let suffixPath = Quickshell.iconPath(rawId.toLowerCase() + "-desktop", true);
                        if (suffixPath) return suffixPath;
                        
                        if (rawId.includes(".")) {
                            let baseName = rawId.split('.').pop().toLowerCase();
                            let dnsPath = Quickshell.iconPath(baseName, true);
                            if (dnsPath) return dnsPath;
                            
                            let dnsSuffixPath = Quickshell.iconPath(baseName + "-desktop", true);
                            if (dnsSuffixPath) return dnsSuffixPath;
                        }

                        return "";
                    }
                }
            }

            Rectangle {
                id: activeIndicator
                width: modelData.activated ? 12 : 6
                height: 4
                radius: 2
                color: modelData.activated ? shellConfig.themeAccent : shellConfig.themeText
                opacity: modelData.activated ? 1.0 : 0.4
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 6
                anchors.horizontalCenter: parent.horizontalCenter
                
                Behavior on width { NumberAnimation { duration: 150 } }
                Behavior on opacity { NumberAnimation { duration: 150 } }
            }

            // --- LOCAL WINDOW-ANCHORED POPUP ---
            PopupWindow {
                id: taskbarTooltipPopup
                visible: trayWindow.activeHoverIndex === index + 100 && !trayWindow.menuActive
                
                anchor.item: clientDelegate
                anchor.edges: Edges.Bottom
                anchor.gravity: Edges.Bottom
                
                // Matches the positioning configuration
                anchor.rect.x: 31
                anchor.rect.y: 55

                implicitWidth: 220
                implicitHeight: 40
                color: "transparent"

                Text {
                    anchors.centerIn: parent
                    text: modelData.title || (desktopEntry ? desktopEntry.name : "") || "Window"
                    font.pointSize: 11
                    font.family: fc.mainFont
                    color: trayWindow.themeText
                    
                    width: parent.width - 24
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            MouseArea {
                id: clientMouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                onEntered: {
                    if (!trayWindow.menuActive) {
                        trayWindow.activeHoverIndex = index + 100;
                    }
                }
                onExited: {
                    if (!trayWindow.menuActive) {
                        trayWindow.activeHoverIndex = -1;
                    }
                }
                onClicked: {
                    if (modelData.wayland) {
                        modelData.wayland.activate()
                    }
                }
            }
        }
    }
}