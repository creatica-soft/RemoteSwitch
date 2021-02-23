//
//  EditDevice.swift
//  test
//
//  Created by AP on 22/02/21.
//

import SwiftUI

struct EditDevice: View {
    @AppStorage("DeviceName") var deviceName = "Remote Switch"
    @AppStorage("DeviceIp") var deviceIp = "192.168.1.44"
    @AppStorage("DevicePort") var devicePort = "4444"
    @AppStorage("DeviceOn") var deviceOn = false
    @State var name = "Remote Switch"
    @State var on = false

    var body: some View {
        Form {
            HStack {
                Text("Name: ")
                TextField("Name", text: $name)
            }
            HStack {
                Text("IP: ")
                TextField("IP", text: $deviceIp)
            }
            HStack {
                Text("UDP Port: ")
                TextField("Port", text: $devicePort)
            }
            Toggle(isOn: $on) {
                Text("On")
            }
        }
        .onDisappear {
            deviceName = name
            deviceOn = on
        }
    }
}

struct EditDevice_Previews: PreviewProvider {
    static var previews: some View {
        EditDevice()
    }
}
