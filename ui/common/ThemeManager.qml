pragma Singleton

import QtQuick 6.8

QtObject {
    id: root
    property bool isDark: true

    onIsDarkChanged: {
        if (typeof loginViewModel !== "undefined") {
            loginViewModel.updateTitleBar(isDark)
        }
    }

    readonly property color bgVault: isDark ? "#1A0F18" : "#FAF3EC"
    readonly property color bgCard: isDark ? "#2A1620" : "#FFFFFF"
    readonly property color bgInput: isDark ? "#1A0F18" : "#FAF3EC"

    readonly property color surfaceElevated: isDark ? "#34192A" : "#F5E6C8"
    readonly property color bgButton: surfaceElevated
    readonly property color bgButtonHover: isDark ? Qt.lighter(surfaceElevated, 1.2) : Qt.darker(surfaceElevated, 1.1)

    readonly property color colorAccent: isDark ? "#E0A526" : "#C9881C"
    readonly property color colorAccentMuted: isDark ? "#B8841C" : "#E8CC8C"

    readonly property color textMain: isDark ? "#F3E9E4" : "#2B1A1F"
    readonly property color textMuted: isDark ? "#A98B95" : "#8A6A75"
    readonly property color lineBorder: isDark ? "#4A2438" : "#E5D5C8"

    // virtual Keyboard specific colors
    readonly property color keyboardBg: isDark ? "#20121D" : "#EAE0D5"
    readonly property color keyBg: isDark ? "#34192A" : "#FFFFFF"
    readonly property color keyBgSpecial: isDark ? "#4A2438" : "#F5E6C8"
    readonly property color keyBgPressed: isDark ? "#5C2C46" : "#E0E0E0"

    readonly property int marginGlobal: 16
    readonly property int radiusDefault: 12
    readonly property int radiusPill: 999
    readonly property int controlHeight: 36 // spacious for desktop, perfect for mobile thumbs

    function toggleTheme() {
        isDark = !isDark
    }
}
