import QtQuick 2.6
import QtQuick.Window 2.2
import QtBluetooth 5.2
import QtQuick.Controls 1.4
import Ossia 1.0 as Ossia

Window {

    id: root
    visible: true
    width: 175
    height: 450
    title: qsTr("metabot bluetooth tester / controller")
    color: "grey"

    maximumHeight: height
    minimumHeight: height
    maximumWidth: width
    minimumWidth: width

    property string message
    property var devices: []

    Ossia.Property on message {
        node: 'message'
    }

    onMessageChanged: {
        console.log(message);
        socket.stringData = message;
        console_logger.append("From OSC: " + message);
    }

    /*BluetoothService {
        id: metabot_scrime_v1
        deviceAddress: "B8:63:BC:00:46:ED"
        serviceName: "SPP Dev"
        serviceUuid: "{00000000-0000-0000-0000-000000000000}"
        serviceProtocol: BluetoothService.L2CapProtocol
    }*/

    BluetoothSocket {

        id: socket
        connected: true

        onConnectedChanged: {
            console.log(connected);
            connection_checkbox.checked = connected;
        }

        onErrorChanged: {
            console.log(error);
            console_logger.append(error)
        }

        onStringDataChanged: {
            console.log("Received Data", socket.stringData);
            console_logger.append("- from device:", socket.stringData);
        }
    }

    BluetoothDiscoveryModel {

        id: bluetooth_discovery
        running: true

        onServiceDiscovered: {
            console.log("Service discovered:", service);
            console.log("Device address:", service.deviceAddress);
            console.log("Device name:", service.deviceName);
            console.log("Service name:", service.serviceName);
            console.log("Service protocol:", service.serviceProtocol);
            console.log("Service description:", service.serviceDescription);
            console.log("Service UUID:", service.serviceUuid);
            //socket.service = service;
            model.append({text: service.deviceName});
            devices.push(service);
        }
    }

    Rectangle {
        color: "white"
        anchors.leftMargin: 0
        anchors.left: parent.left
        anchors.top: parent.top
        width: 175
        height: 27
        anchors.topMargin: 205
        TextInput {
            id: input_commands
            anchors.fill: parent
            onEditingFinished: {
                socket.stringData = text;
                console_logger.append("- to device: " + text);
                this.clear();
            }
        }
    }

    Button {
        id: start_button
        x: 0
        y: 130
        width: 88
        height: 38
        text: "start"
        onClicked: {
            socket.stringData = "start"
        }
    }

    Button {
        id: stop_button
        x: 83
        y: 130
        width: 92
        height: 38
        text: "stop"
        onClicked: {
            socket.stringData = "stop";
        }
    }

    Text {
        id: input_label
        x: 37
        y: 176
        text: qsTr("Input commands")
        font.pixelSize: 12
        font.bold: true
    }

    Rectangle {
        x: 0
        y: 0
        width: 175
        height: 147
        color: "#ffffff"
        anchors.left: parent.left
        anchors.topMargin: 260
        anchors.leftMargin: 0
        anchors.top: parent.top
        TextArea {
            id: console_logger
            anchors.fill: parent
            readOnly: true
        }
    }

    Button {
        id: clear_button
        x: 0
        y: 417
        width: 175
        height: 26
        text: "clear"
        onClicked: {
            console_logger.clear();
        }
    }

    Text {
        id: output_label
        x: 66
        y: 239
        text: qsTr("Output")
        font.bold: true
        font.pixelSize: 12
    }

    CheckBox {
        id: connection_checkbox
        x: 42
        y: 104
        text: qsTr("connected")
        activeFocusOnPress: false
        //enabled: false
    }

    ComboBox {
        id: device_list
        x: 3
        y: 31
        width: 169
        height: 26
        model: ListModel {
            id: model
        }
    }

    Text {
        id: device_selection_label
        x: 38
        y: 10
        text: qsTr("device selection")
        font.pixelSize: 12
        font.bold: true
    }

    Button {
        id: button
        x: 0
        y: 63
        width: 175
        height: 34
        text: qsTr("connect")
        onClicked: {
            socket.service = devices[device_list.currentIndex];
        }
    }

    Component.onCompleted: {
        Ossia.SingleDevice.openOSCQueryServer(5678, 1234)
        Ossia.SingleDevice.recreate(root)
    }
}
