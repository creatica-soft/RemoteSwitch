//
//  devices.switf.swift
//  test
//
//  Created by AP on 20/02/21.
//

import SwiftUI

struct Device: Identifiable {
    var id = UUID()
    var name: String
    var ip: String
    var port: String
    @State var on: Bool
}

extension Device: Equatable {
    static func == (lhs: Device, rhs: Device) -> Bool {
        return lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.ip == rhs.ip &&
            lhs.port == rhs.port &&
            lhs.on == rhs.on
    }
}

#if DEBUG
var testDevices = [
    Device(name: "Engine Fan", ip: "192.168.1.55", port: "7777", on: false),
    Device(name: "Cabin Fan", ip: "192.168.1.66", port: "7777", on: false)
]
#endif
