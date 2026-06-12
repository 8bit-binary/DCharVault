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
        MouseArea {
            anchors.fill: parent
            propagateComposedEvents: true
            hoverEnabled: true
            onPositionChanged: diarySessionModel.reportActivity()
            onPressed: mouse => {
                           diarySessionModel.reportActivity()
                           mouse.accepted = false
            }
        }

        Keys.onPressed: (event) => {
                            diarySessionModel.reportActivity()
                            event.accepted = false
        }
    }

    Connections {
        target: loginViewModel
        function onLoginSuccess() {
            console.log("Main.qml: Vault unlocked. Sliding to HomeView.")
            //without locking the vault. 'replace' destroys the login screen and slides in the new one
            startView.replace("ui/desktop/HomeView.qml",
                              StackView.PushTransition)
        }
    }
    function onVaultLocked() {
        console.log("Main.qml: Vault locked. Sliding back to Login.")
        // slide back to the login screen again and destroy the HomeView (clearing memory).
        stackView.replace("ui/common/login.qml", StackView.PopTransition)
    }
}
