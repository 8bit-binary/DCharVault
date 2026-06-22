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

    property string currentTab: "Appearance"

    // Dim the background behind the popup
    Overlay.modal: Rectangle {
        color: Qt.rgba(0, 0, 0, 0.5)
        Behavior on color {
            ColorAnimation {
                duration: 150
            }
        }
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
                    model: ["Appearance", "Security"]
                    delegate: Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 36
                        radius: ThemeManager.radiusDefault

                        color: modelData
                               === currentTab ? ThemeManager.surfaceElevated : "transparent"

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 12
                            text: modelData
                            font.pixelSize: 14

                            color: modelData
                                   === currentTab ? ThemeManager.textMain : ThemeManager.textMuted
                            font.bold: modelData === currentTab
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                currentTab = modelData
                            }
                        }
                    }
                }

                Item {
                    Layout.fillHeight: true
                }
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

            // Apperance tab
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 32
                anchors.topMargin: 48 // Room for close button
                spacing: 32

                visible: currentTab === "Appearance"

                // Appearance header
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

                            Behavior on color {
                                ColorAnimation {
                                    duration: 150
                                }
                            }

                            Rectangle {
                                x: themeSwitch.checked ? parent.width - width - 2 : 2
                                y: 2
                                width: 24
                                height: 24
                                radius: 12
                                color: "white"
                                border.color: ThemeManager.lineBorder
                                border.width: themeSwitch.checked ? 0 : 1
                                Behavior on x {
                                    NumberAnimation {
                                        duration: 150
                                        easing.type: Easing.InOutQuad
                                    }
                                }
                            }
                        }

                        onCheckedChanged: {
                            if (checked !== ThemeManager.isDark) {
                                ThemeManager.toggleTheme()
                            }
                        }
                    }
                }

                Item {
                    Layout.fillHeight: true
                } // Spacer to push everything up
            }

            // Security tab
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 32
                anchors.topMargin: 48
                spacing: 32

                visible: currentTab === "Security"

                // Security Header
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 8
                    Text {
                        text: "Security"
                        font.pixelSize: 24
                        font.bold: true
                        color: ThemeManager.textMain
                    }
                    Text {
                        text: "Manage Application/Journal Security."
                        color: ThemeManager.textMuted
                        wrapMode: Text.WordWrap
                    }
                }

                // Session Timeout Setting
                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        text: "Session Timeout"
                        font.pixelSize: 16
                        color: ThemeManager.textMain
                        Layout.fillWidth: true
                    }
                    // Dropdown Menu
                    ComboBox {
                        id: timeoutCombo
                        Layout.preferredWidth: 150
                        Layout.preferredHeight: ThemeManager.controlHeight

                        textRole: "text"
                        valueRole: "value"

                        // 1. FIX THE ERROR: Use ListModel instead of a raw JS array
                        model: ListModel {
                            ListElement {
                                text: "1 Minute"
                                value: 60
                            }
                            ListElement {
                                text: "3 Minutes"
                                value: 180
                            }
                            ListElement {
                                text: "7 Minutes"
                                value: 420
                            }
                            ListElement {
                                text: "15 Minutes"
                                value: 900
                            }
                            ListElement {
                                text: "30 Minutes"
                                value: 1800
                            }
                        }

                        // 2. STYLE THE MAIN BUTTON BACKGROUND
                        background: Rectangle {
                            color: ThemeManager.bgInput
                            radius: ThemeManager.radiusDefault
                            border.color: ThemeManager.lineBorder
                            border.width: 1
                        }

                        // 3. STYLE THE SELECTED TEXT
                        contentItem: Text {
                            leftPadding: 12
                            rightPadding: timeoutCombo.indicator.width + timeoutCombo.spacing
                            text: timeoutCombo.displayText
                            font.pixelSize: 14
                            color: ThemeManager.textMain
                            verticalAlignment: Text.AlignVCenter
                            elide: Text.ElideRight
                        }

                        // 4. STYLE THE ARROW ICON
                        indicator: Text {
                            x: timeoutCombo.width - width - 12
                            y: (timeoutCombo.height - height) / 2
                            text: "▼"
                            font.pixelSize: 12
                            color: ThemeManager.textMuted
                        }

                        // 5. STYLE THE DROPDOWN MENU CONTAINER
                        popup: Popup {
                            y: timeoutCombo.height + 4
                            width: timeoutCombo.width
                            implicitHeight: contentItem.implicitHeight
                            padding: 4

                            background: Rectangle {
                                color: ThemeManager.bgCard
                                border.color: ThemeManager.lineBorder
                                border.width: 1
                                radius: ThemeManager.radiusDefault
                            }

                            contentItem: ListView {
                                clip: true
                                implicitHeight: contentHeight
                                model: timeoutCombo.popup.visible ? timeoutCombo.delegateModel : null
                                currentIndex: timeoutCombo.highlightedIndex
                                ScrollIndicator.vertical: ScrollIndicator {}
                            }
                        }

                        // 6. STYLE THE INDIVIDUAL ITEMS INSIDE THE MENU
                        delegate: ItemDelegate {
                            width: timeoutCombo.popup.width - 8
                            height: ThemeManager.controlHeight
                            padding: 12

                            background: Rectangle {
                                radius: ThemeManager.radiusDefault - 4
                                // Highlight the item when hovered or selected
                                color: highlighted ? ThemeManager.surfaceElevated : "transparent"
                            }

                            contentItem: Text {
                                text: model.text
                                color: highlighted ? ThemeManager.textMain : ThemeManager.textMuted
                                font.pixelSize: 14
                                verticalAlignment: Text.AlignVCenter
                            }
                        }

                        Component.onCompleted: {
                            // indexOfValue is a built-in QML function that finds the correct index automatically!
                            let savedValue = diarySessionModel.timeoutSeconds
                            currentIndex = timeoutCombo.indexOfValue(savedValue)
                        }

                        onActivated: {
                            diarySessionModel.setTimeoutSeconds(currentValue)
                        }
                    }
                }

                Item {
                    Layout.fillHeight: true
                }
            }
        }
    }
}
