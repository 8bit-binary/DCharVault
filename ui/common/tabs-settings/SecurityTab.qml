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

    GridLayout {
        Layout.fillWidth: true
        columns: 2
        rowSpacing: 32
        columnSpacing: 16

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

        Text { text: "Clipboard Timeout"; font.pixelSize: 16; color: ThemeManager.textMain; Layout.fillWidth: true }

        DCharComboBox {
            Layout.preferredWidth: 150

            model: ListModel {
                ListElement { text: "10 Seconds"; value: 10 }
                ListElement { text: "30 Seconds"; value: 30 }
                ListElement { text: "1 Minute"; value: 60 }
                ListElement { text: "2 Minutes"; value: 120 }
                ListElement { text: "5 Minutes"; value: 300 }
            }

            Component.onCompleted: currentIndex = indexOfValue(loginViewModel.sanitizer.timeoutSeconds)
            onActivated: loginViewModel.sanitizer.timeoutSeconds = currentValue
        }
    }

    Item { Layout.fillHeight: true }
}
