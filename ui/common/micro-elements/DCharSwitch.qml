import QtQuick
import QtQuick.Controls
import DCharVault

Switch {
    id: control

    indicator: Rectangle {
        implicitWidth: 50
        implicitHeight: 28
        x: control.leftPadding
        y: parent.height / 2 - height / 2
        radius: 14
        color: control.checked ? ThemeManager.colorAccent : ThemeManager.bgInput
        border.color: control.checked ? ThemeManager.colorAccent : ThemeManager.lineBorder

        Behavior on color { ColorAnimation { duration: 150 } }

        Rectangle {
            x: control.checked ? parent.width - width - 2 : 2
            y: 2
            width: 24
            height: 24
            radius: 12
            color: "white"
            border.color: ThemeManager.lineBorder
            border.width: control.checked ? 0 : 1
            Behavior on x { NumberAnimation { duration: 150; easing.type: Easing.InOutQuad } }
        }
    }
}