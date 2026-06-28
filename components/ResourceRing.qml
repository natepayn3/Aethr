import QtQuick
import QtQuick.Controls

Item {
    id: root
    width: 100
    height: 100

    property string ringName: ""
    property real value: 0.0 

    onValueChanged: canvas.requestPaint()

    Canvas {
        id: canvas
        anchors.fill: parent
        antialiasing: true

        onPaint: {
            var ctx = getContext("2d");
            ctx.reset();

            var centreX = width / 2;
            var centreY = height / 2;
            var radius = (width / 2) - 10; 

            // Background Track
            ctx.beginPath();
            ctx.strokeStyle = "rgba(255, 255, 255, 0.05)";
            ctx.lineWidth = 3; 
            ctx.arc(centreX, centreY, radius, 0, 2 * Math.PI, false);
            ctx.stroke();

            // Active Progress Arc
            ctx.beginPath();
            ctx.strokeStyle = "rgba(255, 255, 255, 0.7)";
            ctx.lineWidth = 6;
            ctx.lineCap = "round";
            
            var startAngle = -Math.PI / 2;
            var endAngle = startAngle + (root.value * 2 * Math.PI);
            
            ctx.arc(centreX, centreY, radius, startAngle, endAngle, false);
            ctx.stroke();
        }
    }

    Text {
        text: Math.round(root.value * 100) + "%"
        font.family: "Google Sans Flex" 
        font.pixelSize: 20
        font.weight: Font.Light
        color: Qt.rgba(1, 1, 1, 0.8)
        anchors.centerIn: parent
    }

    Text {
        text: root.ringName
        font.family: "Google Sans Flex"
        font.pixelSize: 12
        font.weight: Font.DemiBold
        color: Qt.rgba(1, 1, 1, 0.5)
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 25
    }
}
