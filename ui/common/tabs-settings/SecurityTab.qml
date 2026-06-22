import QtQuick
import QtQuick.Layouts
import DCharVault

ColumnLayout {
    spacing: 32

    ColumnLayout {
        Layout.fillWidth: true
        spacing: 8
        Text { text: "Security"; font.pixelSize: 24; font.bold: true; color: ThemeManager.textMain }
        Text { text: "Manage Application/Journal Security."; color: ThemeManager.textMuted; wrapMode: Text.WordWrap }
    }

    RowLayout {
        Layout.fillWidth: true
        Text { text: "Session Timeout"; font.pixelSize: 16; color: ThemeManager.textMain; Layout.fillWidth: true }

        DCharComboBox {
            Layout.preferredWidth: 150

            model: ListModel {
                ListElement { text: "1 Minute"; value: 60 }
                ListElement { text: "3 Minutes"; value: 180 }
                ListElement { text: "7 Minutes"; value: 420 }
                ListElement { text: "15 Minutes"; value: 900 }
                ListElement { text: "30 Minutes"; value: 1800 }
            }

            Component.onCompleted: currentIndex = indexOfValue(diarySessionModel.timeoutSeconds)
            onActivated: diarySessionModel.setTimeoutSeconds(currentValue)
        }
    }
    Item { Layout.fillHeight: true }
}
