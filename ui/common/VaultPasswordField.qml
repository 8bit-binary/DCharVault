import QtQuick
import QtQuick.Controls
import Vault.Security 1.0

Rectangle {
    id: root
    property string placeholderText: "Enter Password"

    //Expose underlying C++ component so loginViewModel can access it
    property alias secureInputComponent: secureInput

    //custom signal so parent file knows when Enter is pressed
    signal enterPressed

    color: ThemeManager.bgInput
    border.color: secureInput.activeFocus ? ThemeManager.colorAccent : ThemeManager.lineBorder
    border.width: secureInput.activeFocus ? 2 : 1
    radius: 7

    MouseArea {
        anchors.fill: parent
        onClicked: {
            secureInput.forceActiveFocus()
            if (Qt.platform.os === "android") {
                keyboardPopup.open()
            }
        }
    }

    SecurePasswordInput {
        id: secureInput
        anchors.fill: parent
        focus: true

        Text {
            anchors.fill: parent
            anchors.margins: 12
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 24
            color: ThemeManager.textMain

            // Dynamically creates a string of dots exactly as long as input password
            text: "•".repeat(secureInput.passwordLength)


            // Placeholder text for empty condition
            Text {
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                text: root.placeholderText
                color: "#9ca3af"
                font.pixelSize: 14
                visible: secureInput.passwordLength === 0
            }
        }

        onEnterPressed: {
            if (keyboardPopup.opened) {
                keyboardPopup.close()
            }
            root.enterPressed()
        }
    }

    Popup {
        id: keyboardPopup
        parent: Overlay.overlay
        width: parent ? parent.width : root.width
        height: 350
        y: parent ? parent.height - height : 0
        margins: 0
        padding: 0
        modal: false
        focus: false
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        background: Rectangle {
            color: ThemeManager.keyboardBg
        }

        Loader {
            id: kbLoader
            anchors.fill: parent
            source: Qt.platform.os === "android" ? "../android/virtualKeyboardPad.qml" : ""
            onLoaded: {
                if (item) {
                    console.log("VaultPasswordField: virtualKeyboardPad loaded! Assigning secureInput: " + secureInput)
                    item.targetInput = secureInput
                } else {
                    console.log("VaultPasswordField ERROR: virtualKeyboardPad loaded but item is null!")
                }
            }
        }
        // Failsafe Binding
        Binding {
            target: kbLoader.item
            property: "targetInput"
            value: secureInput
            when: kbLoader.item !== null
        }
    }
}
