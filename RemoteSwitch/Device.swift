//
//  ContentView.swift
//  test
//
//  Created by AP on 12/02/21.
//

import SwiftUI
import Network

struct Device: View {
    @AppStorage("DeviceName") var deviceName = "Remote Switch"
    @AppStorage("DeviceIp") var deviceIp = "192.168.1.44"
    @AppStorage("DevicePort") var devicePort = "4444"
    @AppStorage("DeviceOn") var deviceOn = false
    
    func sendOne() {
        var data = Data(count: 0)
        if deviceOn {
            data.append(contentsOf: [49])
        }
        else {
            data.append(contentsOf: [48])
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
    var body: some View {
        NavigationView {
            Toggle(isOn: $deviceOn) {
                Text(deviceName)
            }
            .padding()
            .onChange(of: deviceOn, perform: { value in
                sendOne()
            })
            .navigationTitle("Remote Switch")
            .frame(height: 560, alignment: .top)
            .toolbar {
                NavigationLink(destination: EditDevice(name: deviceName, on: deviceOn)) {
                    //Label("Edit", systemImage: "homekit")
                    Text("Edit")
                }
            }
        }
    }
    func editDevice() {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Device()
        }
    }
}
