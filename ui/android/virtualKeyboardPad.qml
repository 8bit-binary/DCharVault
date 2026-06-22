import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Vault.Security 1.0

Item {
    id: secureKeyboardArea
    height: 300
    Layout.fillWidth: true

    property var targetInput // The SecurePasswordInput component this keyboard controls


    // State properties
    property int keyboardMode: 0 // 0: letters, 1: symbols1, 2: symbols2
    property bool isShifted: false
    property bool isCapsLocked: false
    property var lastShiftTapTime: 0

    // Models
    readonly property var row1Lower: ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"]
    readonly property var row2Lower: ["a", "s", "d", "f", "g", "h", "j", "k", "l"]
    readonly property var row3Lower: ["z", "x", "c", "v", "b", "n", "m"]

    readonly property var row1Upper: ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"]
    readonly property var row2Upper: ["A", "S", "D", "F", "G", "H", "J", "K", "L"]
    readonly property var row3Upper: ["Z", "X", "C", "V", "B", "N", "M"]

    readonly property var row1Sym1: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
    readonly property var row2Sym1: ["@", "#", "$", "%", "&", "-", "+", "(", ")"]
    readonly property var row3Sym1: ["*", "\"", "'", ":", ";", "!", "?"]

    readonly property var row1Sym2: ["~", "`", "|", "•", "√", "π", "÷", "×", "¶", "∆"]
    readonly property var row2Sym2: ["£", "¢", "€", "¥", "^", "°", "=", "{", "}"]
    readonly property var row3Sym2: ["\\", "©", "®", "™", "✓", "[", "]"]

    function getRow(rowNum) {
        if (keyboardMode === 0) {
            if (isShifted || isCapsLocked) {
                if (rowNum === 1) return row1Upper;
                if (rowNum === 2) return row2Upper;
                if (rowNum === 3) return row3Upper;
            } else {
                if (rowNum === 1) return row1Lower;
                if (rowNum === 2) return row2Lower;
                if (rowNum === 3) return row3Lower;
            }
        } else if (keyboardMode === 1) {
            if (rowNum === 1) return row1Sym1;
            if (rowNum === 2) return row2Sym1;
            if (rowNum === 3) return row3Sym1;
        } else {
            if (rowNum === 1) return row1Sym2;
            if (rowNum === 2) return row2Sym2;
            if (rowNum === 3) return row3Sym2;
        }
    }

    function handleKeyPress(charStr) {
        console.log("Keyboard: Key pressed: " + charStr + ", targetInput: " + targetInput)
        if (targetInput) {
            console.log("Keyboard: Calling targetInput.insertSecureByte...")
            targetInput.insertSecureByte(charStr.charCodeAt(0))
            console.log("Keyboard: Inserted byte, current password length: " + targetInput.passwordLength)
        } else {
            console.log("Keyboard ERROR: targetInput is null or undefined!")
        }

        // Revert shift after one letter, unless caps locked
        if (keyboardMode === 0 && isShifted && !isCapsLocked) {
            isShifted = false
        }
    }

    // Visual indicator (Shows *** instead of characters)
    RowLayout {
        id: indicatorRow
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 10
        spacing: 10 // Added spacing so the indicator dots don't bleed together

        Repeater {
            model: targetInput ? targetInput.passwordLength : 0
            Rectangle {
                width: 15; height: 15; radius: 7.5
                color: ThemeManager.textMain
            }
        }
    }

    // The Custom Keyboard Grid
    GridLayout {
        anchors.top: indicatorRow.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 10

        rowSpacing: 5
        columnSpacing: 5
        columns: 10 // Standard QWERTY layout width

        // --- Row 1 (10 Items -> Fills 10 columns) ---
        Repeater {
            model: getRow(1)

            Button {
                text: modelData
                Layout.fillWidth: true
                Layout.fillHeight: true

                onClicked: {
                    handleKeyPress(modelData)
                }
            }
        }

        // --- Row 2 (1 Spacer + 9 Items -> Fills 10 columns) ---
        // Empty spacer to create the staggered QWERTY look
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        Repeater {
            model: getRow(2)

            Button {
                text: modelData
                Layout.fillWidth: true
                Layout.fillHeight: true

                onClicked: {
                    handleKeyPress(modelData)
                }
            }
        }

        // --- Row 3 (1 Shift + 7 Items + 2 Span Backspace -> Fills 10 columns) ---
        Button {
            text: keyboardMode === 0 ? (isCapsLocked ? "⇪" : (isShifted ? "⬆" : "⇧")) : (keyboardMode === 1 ? "=\\<" : "?123")
            Layout.fillWidth: true
            Layout.fillHeight: true

            onClicked: {
                if (keyboardMode === 0) {
                    let now = new Date().getTime()
                    if (now - lastShiftTapTime < 400) { // 400ms double tap window for Caps Lock
                        isCapsLocked = true
                        isShifted = false
                    } else {
                        if (isCapsLocked) {
                            isCapsLocked = false
                            isShifted = false
                        } else {
                            isShifted = !isShifted
                        }
                    }
                    lastShiftTapTime = now
                } else if (keyboardMode === 1) {
                    keyboardMode = 2
                } else if (keyboardMode === 2) {
                    keyboardMode = 1
                }
            }
        }

        Repeater {
            model: getRow(3)

            Button {
                text: modelData
                Layout.fillWidth: true
                Layout.fillHeight: true

                onClicked: {
                    handleKeyPress(modelData)
                }
            }
        }

        Button {
            text: "⌫"
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.columnSpan: 2 // Spans 2 columns to balance the grid

            onClicked: {
                if (targetInput) targetInput.removeSecureByte()
            }
        }

        // --- Row 4 (2 Span Symbols + 5 Span Space + 3 Span Enter -> Fills 10 columns) ---
        Button {
            text: keyboardMode === 0 ? "?123" : "ABC"
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.columnSpan: 2

            onClicked: {
                if (keyboardMode === 0) {
                    keyboardMode = 1
                } else {
                    keyboardMode = 0
                }
            }
        }

        Button {
            text: "Space"
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.columnSpan: 5

            onClicked: {
                handleKeyPress(" ")
            }
        }

        Button {
            text: "Enter"
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.columnSpan: 3

            onClicked: {
                if (targetInput) targetInput.submitPassword()
            }
        }
    }
}
