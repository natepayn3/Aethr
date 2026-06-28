import QtQuick
import QtQuick.Controls

Item {
    id: sliderRoot

    // Properties passed in from your Dashboard.qml
    property real value: 0.0
    property string iconLow: ""
    property string iconHigh: ""
    
    // Signal to send the new value back to Dashboard.qml
    signal moved(real newValue)

    // The text string we want to display (e.g., "75%")
    property string percentageText: Math.round(sliderRoot.value * 100) + "%"

    // 1. BACKGROUND TRACK (The empty part)
    Rectangle {
        id: bgTrack
        anchors.fill: parent
        color: Qt.rgba(rootShell.colorText.r, rootShell.colorText.g, rootShell.colorText.b, 0.15) // Light transparent background
        radius: height / 2

        // LIGHT TEXT: Sits in the background
        Text {
            anchors.centerIn: parent
            text: sliderRoot.percentageText
            color: rootShell.colorText // Normal text color
            font.family: rootShell.shellFont
            font.pixelSize: 14
            font.bold: true
        }
    }

    // 2. FILL BAR (The colored part that moves)
    Rectangle {
        id: fillBar
        height: parent.height
        width: Math.max(height, sliderRoot.width * sliderRoot.value) // Keeps it from getting smaller than a circle
        color: rootShell.colorText // Solid accent color
        radius: height / 2
        
        // 🎯 THE CLIPPING MAGIC
        clip: true 

        // DARK TEXT: Sits inside the moving bar
        Text {
            // Absolute positioning relative to the main slider, NOT the fill bar!
            x: (sliderRoot.width - width) / 2
            y: (sliderRoot.height - height) / 2
            
            text: sliderRoot.percentageText
            color: rootShell.colorBackground // Dark background color to contrast the solid bar
            font.family: rootShell.shellFont
            font.pixelSize: 14
            font.bold: true
        }
    }

    // 3. YOUR ICONS (Optional: you can clip these too if they overlap the bar!)
    Text {
        anchors.left: parent.left
        anchors.leftMargin: 14
        anchors.verticalCenter: parent.verticalCenter
        text: sliderRoot.iconLow
        font.family: "Material Symbols Outlined"
        font.pixelSize: 20
        color: sliderRoot.value > 0.1 ? rootShell.colorBackground : rootShell.colorText
    }

    // 4. INTERACTION LOGIC
    MouseArea {
        id: dragArea
        anchors.fill: parent
        
        // Emits true when the user is actively dragging
        property bool isPressed: pressed

        onPositionChanged: (mouse) => {
            if (pressed) {
                // Calculate the new percentage based on mouse X position
                let newPct = Math.max(0.0, Math.min(1.0, mouse.x / width));
                sliderRoot.moved(newPct);
            }
        }
        
        onClicked: (mouse) => {
            let newPct = Math.max(0.0, Math.min(1.0, mouse.x / width));
            sliderRoot.moved(newPct);
        }
    }
}
