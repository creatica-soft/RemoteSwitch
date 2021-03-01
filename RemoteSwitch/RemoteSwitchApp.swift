import SwiftUI

let defaultName = "Remote Switch"
let defaultIp = "0.0.0.0"
let defaultPort = "0"
let defaultOn = false
let asciiCharOne = UInt8(49)
let asciiCharZero = UInt8(48)

@main
struct remoteSwitchApp: App {
    var body: some Scene {
        WindowGroup {
            Device()
        }
    }
}
