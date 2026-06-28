import QtQuick

QtObject {
    id: fontConfig

    // --- TYPOGRAPHY FAMILIES ---
    property string mainFont: "Google Sans Flex"
    property string monoFont: "JetBrains Mono"
    property string iconFont: "Material Symbols Outlined"

    // --- ENHANCED SMOOTHING INJECTOR ---
    // Passes system FreeType rendering profiles directly to components
    property int preferredRenderType: Text.NativeRendering
    property bool useAntialiasing: true

    // --- HELPER FACTORIES ---
    // Safely constructs localized styling attributes if needed
    function applySmoothing(targetTextElement) {
        if (targetTextElement) {
            targetTextElement.renderType = preferredRenderType;
            targetTextElement.antialiasing = useAntialiasing;
        }
    }
}
