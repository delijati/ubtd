import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import QtBluetooth 5.4
import Shareplugin 0.1
import Ubuntu.Content 1.3

MainView {
    id: root
    applicationName: "ubtd.mzanetti"

    width: units.gu(100)
    height: units.gu(75)

    property string fileName
    property bool peerSelected: false

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

    Timer { id: scheduleRestart; interval: 1000; onTriggered: btModel.running = true; }

    BluetoothDiscoveryModel {
        id: btModel
        property bool continuousDiscovery: true
        onContinuousDiscoveryChanged: {
            if (continuousDiscovery && !running) {
                running = true;
            } else if (!continuousDiscovery && running) {
                running = false;
            }
        }

        // Workaround for width not being set when we start the animation
        Component.onCompleted: scheduleRestart.start()
        running: false

        onRunningChanged: {
            if (!running && continuousDiscovery) {
                scheduleRestart.start()
            }
        }

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
        id: page
        header: PageHeader {
            title: i18n.tr("Share via Bluetooth")
            leadingActionBar.actions: [
                Action {
                    iconName: "close"
                    onTriggered: Qt.quit()
                }

            ]
        }

        Rectangle {
            id: progressBar
            anchors {
                left: parent.left; top: parent.top; right: parent.right; topMargin: page.header.height
            }
            height: units.dp(5)
            visible: btModel.running
            Rectangle {
                id: progressElement
                width: parent.width / 3
                height: parent.height
                color: UbuntuColors.blue
            }
            property int targetX: page.width - progressElement.width
            onTargetXChanged: {
                if (visible) {
                    inquiryAnimation.restart()
                }
            }
            SequentialAnimation {
                id: inquiryAnimation
                loops: Animation.Infinite
                running: progressBar.visible
                NumberAnimation {
                    target: progressElement
                    duration: 2000
                    property: "x"
                    from: 0
                    to: progressBar.targetX
                }
                NumberAnimation {
                    target: progressElement
                    property: "x"
                    duration: 2000
                    from: progressBar.targetX
                    to: 0
                }
            }
        }

        GridLayout {
            anchors.fill: parent
            anchors.topMargin: page.header.height + progressBar.height
            columns: width > height ? 2 : 1

            Item {
                Layout.fillHeight: true
                Layout.fillWidth: true

                Image {
                    id: transferredImage
                    anchors.fill: parent
                    anchors.margins: units.gu(2)
                    source: "file://" + root.fileName
                    fillMode: Image.PreserveAspectFit
                }
                Icon {
                    anchors.fill: parent
                    anchors.margins: units.gu(2)
                    visible: transferredImage.status === Image.Error || !root.fileName
                    name: {
                        var extension = root.fileName.split(".").pop()
                        switch(extension) {
                        case "pdf":
                            return "application-pdf-symbolic";
                        case "tar":
                        case "gz":
                        case "gzip":
                        case "zip":
                        case "xz":
                            return "application-x-archive-symbolic";
                        case "mp3":
                        case "ogg":
                        case "wav":
                        case "flac":
                            return "audio-x-generic-symbolic";
                        case "jpg":
                        case "gif":
                        case "jpeg":
                        case "png":
                        case "webp":
                            return "image-x-generic-symbolic";
                        case "click":
                        case "deb":
                            return "package-x-generic-symbolic";
                        case "txt":
                            return "text-generic-symbolic";
                        case "mp4":
                        case "mkv":
                        case "avi":
                        case "mpeg":
                        case "mpg":
                            return "video-x-generic-symbolic";
                        default:
                            return "empty-symbolic";
                        }
                    }
                }
            }

            Item {
                Layout.fillHeight: true
                Layout.fillWidth: true

                ListView {
                    anchors.fill: parent
                    model: btModel
                    visible: !root.peerSelected
                    clip: true

                    delegate: ListItem {
                        height: units.gu(6)
                        Label {
                            anchors.centerIn: parent
                            text: (deviceName ? deviceName : name)
                        }
                        onClicked: {
                            btModel.continuousDiscovery = false;
                            transfer.sendFile(remoteAddress, root.fileName)
                            root.peerSelected = true;
                        }
                    }
                }

                ColumnLayout {
                    width: parent.width - units.gu(4)
                    anchors.centerIn: parent
                    spacing: units.gu(2)
                    visible: root.peerSelected
                    Label {
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                        text: transfer.error ? "Transfer failed."
                                : transfer.finished ? "File transferred."
                                : "Transferring file..."
                        fontSize: "large"
                    }

                    ProgressBar {
                        Layout.fillWidth: true
                        value: transfer.progress
                        visible: !transfer.finished && !transfer.error
                    }

                    Button {
                        Layout.fillWidth: true
                        text: i18n.tr("Close")
                        color: transfer.error ? UbuntuColors.red : UbuntuColors.green
                        onClicked: Qt.quit();
                        visible: transfer.finished || transfer.error
                    }
                }

            }
        }
    }
}

