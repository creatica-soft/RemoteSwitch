import SwiftUI

struct EditDevice: View {
    @AppStorage("DeviceName") var deviceName = defaultName
    @AppStorage("DeviceIp") var deviceIp = defaultIp
    @AppStorage("DevicePort") var devicePort = defaultPort
    @AppStorage("DeviceOn") var deviceOn = defaultOn
    @State var name = defaultName
    @State var on = defaultOn

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
