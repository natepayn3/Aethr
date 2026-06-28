import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: launcherWindow
    
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    
    WlrLayershell.layer: WlrLayer.Overlay
    exclusionMode: ExclusionMode.Ignore
    color: "transparent" // Make window frame transparent, animate content backing instead
    
    visible: false
    
    // Explicit controls exposed to the anchor toggle
    function toggle() {
        if (visible) {
            fadeOutAnim.start();
        } else {
            visible = true;
            fadeInAnim.start();
        }
    }

    // Root visual content wrapper to handle opacity transformations safely
    Item {
        id: container
        anchors.fill: parent
        opacity: 0.0

        // Subtle dimming matrix
        Rectangle {
            anchors.fill: parent
            color: Qt.rgba(0, 0, 0, 0.25)
        }

        // Dismiss overlay on background click
        MouseArea {
            anchors.fill: parent
            onClicked: launcherWindow.toggle()
        }

        // Main App Launcher Layout Container Block
        Rectangle {
            id: menuSurface
            width: 640
            height: 440
            radius: 16
            color: Qt.rgba(0.06, 0.06, 0.06, 0.9)
            anchors.centerIn: parent
            
            Text {
                anchors.centerIn: parent
                text: "App Launcher Viewport"
                color: "white"
                font.family: "Google Sans Flex"
                font.pixelSize: 18
            }
        }
    }

    // Precise transition driving animations on the content wrapper
    NumberAnimation {
        id: fadeInAnim
        target: container
        property: "opacity"
        to: 1.0
        duration: 180
        easing.type: Easing.OutCubic
    }

    NumberAnimation {
        id: fadeOutAnim
        target: container
        property: "opacity"
        to: 0.0
        duration: 180
        easing.type: Easing.OutCubic
        onStopped: launcherWindow.visible = false
    }
}