import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import DCharVault

ApplicationWindow {
    id: rootWindow

    width: 800
    height: 700
    visible: true
    title: "DCharVault"

    Item {
        id: sessionRoot
        anchors.fill: parent
        focus: true
        StackView {
            id: startView
            anchors.fill: parent
            initialItem: "ui/common/login.qml"
        }
    }

    Connections {
        target: loginViewModel
        function onLoginSuccess() {
            if (diarySessionModel.isLocked) {
                diarySessionModel.onUnlockSuccess() // reset state→Active, restart idle clock
            }
            console.log("Main.qml: Vault unlocked. Sliding to HomeView.")
            //without locking the vault. 'replace' destroys the login screen and slides in the new one
            startView.replace("ui/desktop/HomeView.qml",
                              StackView.PushTransition)
        }
    }
    Connections {
        target: diarySessionModel
        function onSessionLocked() {
            console.log("Main.qml: SECURITY TIMEOUT. Purging UI state.")
            startView.replace("ui/common/login.qml", StackView.PopTransition)
            gc()
        }
    }
}
