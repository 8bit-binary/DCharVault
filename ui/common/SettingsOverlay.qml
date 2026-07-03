import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import DCharVault

Popup {
    id: root
    width: 650; height: 450
    modal: true; focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    property string currentTab: "Appearance"

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

        // Left Sidebar
        Rectangle {
            Layout.preferredWidth: 200
            Layout.fillHeight: true
            color: "transparent"

            Rectangle { width: 1; height: parent.height; color: ThemeManager.lineBorder; anchors.right: parent.right }

            ColumnLayout {
                anchors.fill: parent; anchors.margins: 16; spacing: 4

                Text { text: "Settings"; font.pixelSize: 18; font.bold: true; color: ThemeManager.textMain; Layout.bottomMargin: 16; Layout.leftMargin: 8 }

                Repeater {
                    model: ["Appearance", "Security"]
                    delegate: Rectangle {
                        Layout.fillWidth: true; Layout.preferredHeight: 36; radius: ThemeManager.radiusDefault
                        color: modelData === currentTab ? ThemeManager.surfaceElevated : "transparent"

                        Text {
                            anchors.verticalCenter: parent.verticalCenter; anchors.left: parent.left; anchors.leftMargin: 12
                            text: modelData; font.pixelSize: 14
                            color: modelData === currentTab ? ThemeManager.textMain : ThemeManager.textMuted
                            font.bold: modelData === currentTab
                        }
                        MouseArea {
                            anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                            onClicked: currentTab = modelData
                        }
                    }
                }
                Item { Layout.fillHeight: true }
            }
        }

        // Right Content Area
        Item {
            Layout.fillWidth: true; Layout.fillHeight: true

            ToolButton {
                anchors.top: parent.top; anchors.right: parent.right; anchors.margins: 16
                text: "✕"; font.pixelSize: 18; background: null
                contentItem: Text { text: parent.text; color: ThemeManager.textMuted; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                onClicked: root.close()
            }

            Loader {
                anchors.fill: parent
                anchors.margins: 32
                anchors.topMargin: 48
                source: "tabs-settings/" + currentTab + "Tab.qml"
            }
        }
    }
}
