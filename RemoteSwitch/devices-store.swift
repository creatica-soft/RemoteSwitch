//
//  devices-store.swift
//  test
//
//  Created by AP on 20/02/21.
//

import Foundation
import Combine

class DeviceStore: BindableObject {
    var devices = [Device] {
        didSet { didChange.send() }
    }
    
    init(devices: [Device] = []) {
        self.devices = devices
    }
    
    var didChange = PassthroughSubject<Void, Never>()
}
