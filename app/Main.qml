import QtQuick 2.0
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.2

MainView {
    applicationName: "ubtd.mzanetti"


    width: units.gu(100)
    height: units.gu(75)

    Page {
        title: i18n.tr("Bluetooth file transfer")

        ColumnLayout {
            spacing: units.gu(1)
            anchors {
                margins: units.gu(1)
                fill: parent
            }

            Label {
                id: label
                text: i18n.tr("Waiting for incoming file...")
                fontSize: "large"
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
            }
            Label {
                text: i18n.tr("Send a file via Bluetooth to your Ubuntu phone")
                fontSize: "x-small"
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
            }
            ListView {
                Layout.fillHeight: true
                Layout.fillWidth: true

                model: obexd

                delegate: ListItem {
                    height: units.gu(10)
                    RowLayout {
                        anchors { fill: parent; margins: units.gu(1) }
                        Image {
                            Layout.fillHeight: true
                            Layout.preferredWidth: height
                            source: completed ? (success ? "file://" + filePath + filename : "image://theme/close") : "image://theme/empty-symbolic"
                            fillMode: Image.PreserveAspectFit
                        }

                        ColumnLayout {
                            Label {
                                Layout.fillWidth: true
                                text: filename
                            }
                            UbuntuShape {
                                Layout.fillWidth: true
                                Layout.preferredHeight: units.dp(5)
                                UbuntuShape {
                                    anchors.fill: parent
                                    color: UbuntuColors.orange
                                    // trans : total = x : width
                                    anchors.rightMargin: parent.width - (transferred * parent.width / size)
                                }
                            }
                            Label {
                                text: completed ? (success ? "Completed" : "Failed") : "Transferring..."
                            }
                        }
                    }
                }
            }
        }
    }
}

