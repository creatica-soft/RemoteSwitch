import SwiftUI
import Network

struct Device: View {
    @AppStorage("DeviceName") var deviceName = defaultName
    @AppStorage("DeviceIp") var deviceIp = defaultIp
    @AppStorage("DevicePort") var devicePort = defaultPort
    @AppStorage("DeviceOn") var deviceOn = defaultOn
    
    var body: some View {
        NavigationView {
            Toggle(isOn: $deviceOn) {
                Text(deviceName)
            }
            .onChange(of: deviceOn, perform: { value in
                send()
            })
            .frame(height: 560, alignment: .top)
            .toolbar {
                NavigationLink(destination: EditDevice(name: deviceName, on: deviceOn)) {
                    Text("Edit")
                }
            }
            .navigationTitle("Remote Switch")
            .padding()
        }
    }
    
    func send() {
        var data = Data(count: 0)
        if deviceOn {
            data.append(contentsOf: [asciiCharOne])
        }
        else {
            data.append(contentsOf: [asciiCharZero])
        }
        let ip4 = IPv4Address(deviceIp)!
        let host = NWEndpoint.Host.ipv4(ip4)
        let port = NWEndpoint.Port(devicePort)!
        let endpoint = NWEndpoint.hostPort(host: host, port: port)
        let udpOption = NWProtocolUDP.Options()
        let params = NWParameters(dtls: nil, udp: udpOption)
        params.requiredInterfaceType = NWInterface.InterfaceType.wifi
        params.prohibitExpensivePaths = true
        params.preferNoProxies = true
        params.expiredDNSBehavior = NWParameters.ExpiredDNSBehavior.allow
        params.prohibitedInterfaceTypes = [.cellular]
        let conn = NWConnection(to: endpoint, using: params)
/*
        conn.stateUpdateHandler = { latestState in
            switch latestState {
            case .waiting(_):
                if case .localNetworkDenied? = conn.currentPath?.unsatisfiedReason {
                    NSLog("unssatisfied reason")
                }
            case .setup:
                NSLog("conn setup")
            case .preparing:
                NSLog("conn prep")
            case .ready:
                NSLog("conn ready")
            case .failed(_):
                NSLog("conn failed")
            case .cancelled:
                NSLog("conn canceled")
            @unknown default:
                NSLog("conn unknown")
            }
        }
 */
        conn.start(queue: .main)
        conn.send(content: data, completion: NWConnection.SendCompletion.contentProcessed({ err in
            if err != nil {
                switch(err){
                case .posix(let errcode):
                    NSLog("conn.send POSIXErrorCode: \(errcode)")
                case .dns(let dnserr):
                    NSLog("conn.send DNSServiceErrorType: \(dnserr)")
                case .tls(let osstat):
                    NSLog("conn.send OSStatus: \(osstat)")
                case .none:
                    NSLog("conn.send err none")
                case .some(let someerr):
                    NSLog("conn.send err \(someerr)")
                }
                NSLog("Error message: \(err.debugDescription)")
            }
            else {
                NSLog("sent %c", data[0])
            }
        }))
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Device()
        }
    }
}
