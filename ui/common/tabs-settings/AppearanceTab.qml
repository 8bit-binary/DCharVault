import QtQuick
import QtQuick.Layouts
import DCharVault

ColumnLayout {
    spacing: 32

    ColumnLayout {
        Layout.fillWidth: true
        spacing: 8
        Text { text: "Appearance"; font.pixelSize: 24; font.bold: true; color: ThemeManager.textMain }
        Text { text: "Configure the app's visual theme and display preferences."; color: ThemeManager.textMuted; wrapMode: Text.WordWrap; Layout.fillWidth: true }
    }

    RowLayout {
        Layout.fillWidth: true
        Text { text: "Dark Mode"; font.pixelSize: 16; color: ThemeManager.textMain; Layout.fillWidth: true }

        DCharSwitch {
            checked: ThemeManager.isDark
            onCheckedChanged: {
                if (checked !== ThemeManager.isDark) ThemeManager.toggleTheme()
            }
        }
    }
    Item { Layout.fillHeight: true }
}
