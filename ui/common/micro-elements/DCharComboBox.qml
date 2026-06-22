import QtQuick
import QtQuick.Controls
import DCharVault

ComboBox {
    id: control
    implicitHeight: ThemeManager.controlHeight
    textRole: "text"
    valueRole: "value"

    background: Rectangle {
        color: ThemeManager.bgInput
        radius: ThemeManager.radiusDefault
        border.color: ThemeManager.lineBorder
        border.width: 1
    }

    contentItem: Text {
        leftPadding: 12
        rightPadding: control.indicator.width + control.spacing
        text: control.displayText
        font.pixelSize: 14
        color: ThemeManager.textMain
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    indicator: Text {
        x: control.width - width - 12
        y: (control.height - height) / 2
        text: "▼"
        font.pixelSize: 12
        color: ThemeManager.textMuted
    }

    popup: Popup {
        y: control.height + 4
        width: control.width
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
            model: control.popup.visible ? control.delegateModel : null
            currentIndex: control.highlightedIndex
            ScrollIndicator.vertical: ScrollIndicator {}
        }
    }

    delegate: ItemDelegate {
        width: control.popup.width - 8
        height: ThemeManager.controlHeight
        padding: 12
        background: Rectangle {
            radius: ThemeManager.radiusDefault - 4
            color: highlighted ? ThemeManager.surfaceElevated : "transparent"
        }
        contentItem: Text {
            text: model.text
            color: highlighted ? ThemeManager.textMain : ThemeManager.textMuted
            font.pixelSize: 14
            verticalAlignment: Text.AlignVCenter
        }
    }
}
