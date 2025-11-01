import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

import ImageViewing

ApplicationWindow {
    id: appWindow
    width: 800
    height: 600
    visible: true
    title: qsTr("SpriteConverter")

    property string save_path: "";

    function enableUI(enabled) {
        actionClose.enabled = enabled;
        actionSave.enabled = enabled;
        actionSaveAs.enabled = enabled;
        imageView.enabled = enabled;
        colorKeyText.enabled = enabled;
        colorKeyRect.enabled = enabled;
        changeColorKeyButton.enabled = enabled;
        scalingText.enabled = enabled;
        scalingSlider.enabled = enabled;
        scalingLabel.enabled = enabled;
    }

    SystemPalette { id: systemPalette }

    header: MenuBar {
        Menu {
            title: qsTr("&File")

            Action {
                text: qsTr("&Open...")
                icon.name: "document-open"
                shortcut: StandardKey.Open
                onTriggered: openImageDialog.open()
            }
            Action {
                id: actionClose
                text: qsTr("Close")
                icon.name: "document-close" //  non-standard, but works in KDE
                shortcut: "Ctrl+W"  //  getting complaints when using StandardKey.Close
                enabled: false
                onTriggered: {
                    imageView.setImage("");
                    appWindow.save_path = "";
                    enableUI(false);
                }
            }
            MenuSeparator {}
            Action {
                id: actionSave
                text: qsTr("&Save")
                icon.name: "document-save"
                shortcut: StandardKey.Save
                enabled: false
                onTriggered: {
                    if (appWindow.save_path)
                        imageView.saveTo(appWindow.save_path);
                    else
                        saveImageDialog.open();
                }
            }
            Action {
                id: actionSaveAs
                text: qsTr("Save as...")
                icon.name: "document-save-as"
                shortcut: StandardKey.SaveAs
                enabled: false
                onTriggered: saveImageDialog.open()
            }
            MenuSeparator {}
            Action {
                text: qsTr("&Quit")
                icon.name: "application-exit"
                shortcut: StandardKey.Quit
                onTriggered: Qt.quit()
            }
        }
    }

    FileDialog {
        id: openImageDialog
        fileMode: FileDialog.OpenFile
        nameFilters: qsTr("Texture files (*.png *.bmp *.jpg)")
        onAccepted: {
            imageView.setImage(selectedFile);
            appWindow.save_path = selectedFile;
            enableUI(true);
        }
    }

    FileDialog {
        id: saveImageDialog
        fileMode: FileDialog.SaveFile
        defaultSuffix: ".png"
        onAccepted: {
            if (selectedFile)
            {
                imageView.saveTo(selectedFile);
                appWindow.save_path = selectedFile;
            }
        }
    }

    ColorDialog {
        id: colorDialog
        selectedColor: colorKeyRect.color
        onAccepted: {
            colorKeyRect.color = selectedColor;
            imageView.setColorKey(selectedColor);
        }
    }

    ScrollView {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: bottomRow.top
        anchors.margins: 8

        ImageView {
            id: imageView
            anchors.left: parent.left
            anchors.top: parent.top
            enabled: false
            onColorKeySet: color_key => {
                colorKeyRect.color = color_key;
                imageView.setColorKey(color_key);
            }
        }
    }

    Row {
        id: bottomRow
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: 8
        spacing: 8

        Label {
            id: colorKeyText
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("Color key :")
            enabled: false
        }
        Rectangle {
            id: colorKeyRect
            color: Qt.black
            width: 32
            height: 32
            enabled: false
        }
        Button {
            id: changeColorKeyButton
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("Change...")
            enabled: false
            onClicked: {
                colorDialog.selectedColor = colorKeyRect.color;
                colorDialog.open();
            }
        }

        Rectangle { color: systemPalette.mid; width: 2; height: 32 }

        Label {
            id: scalingText
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("Scaling :")
            enabled: false
        }
        Slider {
            id: scalingSlider
            anchors.verticalCenter: parent.verticalCenter
            from: 0.1; to: 10; stepSize: 0.1
            value: 1
            enabled: false
            onValueChanged: {
                scalingLabel.text = value.toFixed(1) + "x";
                imageView.setScaling(value);
            }
        }
        Label {
            id: scalingLabel
            anchors.verticalCenter: parent.verticalCenter
            text: "1x"
            enabled: false
        }
    }
}
