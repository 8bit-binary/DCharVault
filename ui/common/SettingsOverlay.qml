import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import DCharVault

Popup {
    id: root
    width: 320
    height: 400
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    // Dim the background behind the popup
    Overlay.modal: Rectangle {
        color: Qt.rgba(0, 0, 0, 0.5)
    }

    background: Rectangle {
        color: ThemeManager.bgCard
        radius: ThemeManager.radiusDefault
        border.color: ThemeManager.lineBorder
        border.width: 1
    }

    contentItem: ColumnLayout {
        anchors.fill: parent
        anchors.margins: ThemeManager.marginGlobal
        spacing: 20

        // Header
        RowLayout {
            Layout.fillWidth: true

            Text {
                text: "Settings"
                font.pixelSize: 24
                font.bold: true
                color: ThemeManager.textMain
                Layout.fillWidth: true
            }

            ToolButton {
                text: "✕"
                font.pixelSize: 18
                background: null
                contentItem: Text {
                    text: parent.text
                    color: ThemeManager.textMuted
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: root.close()
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: ThemeManager.lineBorder
        }

        // Appearance Section
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 12

            Text {
                text: "Appearance"
                font.pixelSize: 14
                font.bold: true
                color: ThemeManager.textSecondary
                Layout.bottomMargin: 4
            }

            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: "Dark Mode"
                    font.pixelSize: 16
                    color: ThemeManager.textMain
                    Layout.fillWidth: true
                }

                Switch {
                    id: themeSwitch
                    checked: ThemeManager.isDark
                    onCheckedChanged: {
                        if (checked !== ThemeManager.isDark) {
                            ThemeManager.toggleTheme()
                        }
                    }
                }
            }
        }

        Item {
            Layout.fillHeight: true // Push everything up
        }
    }
}
