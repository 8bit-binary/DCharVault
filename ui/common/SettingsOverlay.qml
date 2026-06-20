import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import DCharVault

Popup {
    id: root
    width: 650
    height: 450
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    // Dim the background behind the popup
    Overlay.modal: Rectangle {
        color: Qt.rgba(0, 0, 0, 0.5)
        Behavior on color { ColorAnimation { duration: 150 } }
    }

    background: Rectangle {
        color: ThemeManager.bgCard
        radius: ThemeManager.radiusDefault
        border.color: ThemeManager.lineBorder
        border.width: 1
    }

    contentItem: RowLayout {
        anchors.fill: parent
        spacing: 0

        // Left Sidebar (Tabs)
        Rectangle {
            Layout.preferredWidth: 200
            Layout.fillHeight: true
            color: "transparent"

            // Vertical separator line
            Rectangle {
                width: 1
                height: parent.height
                color: ThemeManager.lineBorder
                anchors.right: parent.right
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 4

                Text {
                    text: "Settings"
                    font.pixelSize: 18
                    font.bold: true
                    color: ThemeManager.textMain
                    Layout.bottomMargin: 16
                    Layout.leftMargin: 8
                }

                Repeater {
                    model: ["Appearance"]
                    delegate: Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 36
                        radius: ThemeManager.radiusDefault
                        color: modelData === "Appearance" ? ThemeManager.surfaceElevated : "transparent"

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 12
                            text: modelData
                            font.pixelSize: 14
                            color: modelData === "Appearance" ? ThemeManager.textMain : ThemeManager.textMuted
                            font.bold: modelData === "Appearance"
                        }
                    }
                }

                Item { Layout.fillHeight: true }
            }
        }

        // Right Content Area
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            // Close button at top right
            ToolButton {
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.margins: 16
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

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 32
                anchors.topMargin: 48 // Room for close button
                spacing: 32

                // Section Header
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    Text {
                        text: "Appearance"
                        font.pixelSize: 24
                        font.bold: true
                        color: ThemeManager.textMain
                    }

                    Text {
                        text: "Configure the app's visual theme and display preferences."
                        font.pixelSize: 14
                        color: ThemeManager.textMuted
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                    }
                }

                // Theme Toggle Setting
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

                        indicator: Rectangle {
                            implicitWidth: 50
                            implicitHeight: 28
                            x: themeSwitch.leftPadding
                            y: parent.height / 2 - height / 2
                            radius: 14
                            color: themeSwitch.checked ? ThemeManager.colorAccent : ThemeManager.bgInput
                            border.color: themeSwitch.checked ? ThemeManager.colorAccent : ThemeManager.lineBorder

                            Behavior on color { ColorAnimation { duration: 150 } }

                            Rectangle {
                                x: themeSwitch.checked ? parent.width - width - 2 : 2
                                y: 2
                                width: 24
                                height: 24
                                radius: 12
                                color: "white"
                                border.color: ThemeManager.lineBorder
                                border.width: themeSwitch.checked ? 0 : 1
                                Behavior on x { NumberAnimation { duration: 150; easing.type: Easing.InOutQuad } }
                            }
                        }

                        onCheckedChanged: {
                            if (checked !== ThemeManager.isDark) {
                                ThemeManager.toggleTheme()
                            }
                        }
                    }
                }

                Item { Layout.fillHeight: true }
            }
        }
    }
}
