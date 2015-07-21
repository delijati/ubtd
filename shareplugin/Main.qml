import QtQuick 2.0
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.2
import QtBluetooth 5.2
import Shareplugin 0.1
import Ubuntu.Content 1.1

MainView {
    id: root
    applicationName: "ubtd.mzanetti"

    width: units.gu(100)
    height: units.gu(75)

    property string fileName

    BtTransfer {
        id: transfer
    }

    Connections {
        target: ContentHub

        onShareRequested: {
            var filePath = String(transfer.items[0].url).replace('file://', '')
            print("Should share file", filePath)
            root.fileName = filePath;
        }
    }

    BluetoothDiscoveryModel {
        id: btModel
        running: true
        discoveryMode: BluetoothDiscoveryModel.DeviceDiscovery
        onDiscoveryModeChanged: console.log("Discovery mode: " + discoveryMode)
        onServiceDiscovered: console.log("Found new service " + service.deviceAddress + " " + service.deviceName + " " + service.serviceName);
        onDeviceDiscovered: console.log("New device: " + device)
        onErrorChanged: {
            switch (btModel.error) {
            case BluetoothDiscoveryModel.PoweredOffError:
                console.log("Error: Bluetooth device not turned on"); break;
            case BluetoothDiscoveryModel.InputOutputError:
                console.log("Error: Bluetooth I/O Error"); break;
            case BluetoothDiscoveryModel.InvalidBluetoothAdapterError:
                console.log("Error: Invalid Bluetooth Adapter Error"); break;
            case BluetoothDiscoveryModel.NoError:
                break;
            default:
                console.log("Error: Unknown Error"); break;
            }
        }
    }

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
                text: i18n.tr("Searching for bluetooth devices")
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

                model: btModel

                ActivityIndicator {
                    anchors.centerIn: parent
                    running: btModel.running
                }

                delegate: ListItem {
                    height: units.gu(6)
                    Label {
                        anchors.centerIn: parent
                        text: (deviceName ? deviceName : name) + "(" + remoteAddress + ")"
                    }
                    onClicked: {
                        transfer.sendFile(remoteAddress, root.fileName)
                    }

//                    RowLayout {
//                        anchors { fill: parent; margins: units.gu(1) }
//                        Image {
//                            Layout.fillHeight: true
//                            Layout.preferredWidth: height
//                            source: completed ? (success ? "file://" + filePath + filename : "image://theme/close") : "image://theme/empty-symbolic"
//                            fillMode: Image.PreserveAspectFit
//                        }

//                        ColumnLayout {
//                            Label {
//                                Layout.fillWidth: true
//                                text: filename
//                            }
//                            UbuntuShape {
//                                Layout.fillWidth: true
//                                Layout.preferredHeight: units.dp(5)
//                                UbuntuShape {
//                                    anchors.fill: parent
//                                    color: UbuntuColors.orange
//                                    // trans : total = x : width
//                                    anchors.rightMargin: parent.width - (transferred * parent.width / size)
//                                }
//                            }
//                            Label {
//                                text: completed ? (success ? "Completed" : "Failed") : "Transferring..."
//                            }
//                        }
//                    }
                }
            }
        }
    }
}

