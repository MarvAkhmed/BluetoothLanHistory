//
//  BluetoothDevice.swift
//  NetworkScanner
//
//  Created by Marwa Awad on 26.10.2025.
//

import CoreBluetooth

struct BluetoothDevice: Identifiable, Equatable {
    
    // MARK: - Private Properties
    var id = UUID()
    var name: String?
    var uuid: String
    var rssi: Int
    var status: CBPeripheralState
}

// MARK: - CBPeripheralState Extension
extension CBPeripheralState {
    var displayName: String {
        switch self {
        case .connected: return "Connected"
        case .connecting: return "Connecting"
        case .disconnected: return "Disconnected"
        case .disconnecting: return "Disconnecting"
        @unknown default: return "Unknown"
        }
    }
}

extension BluetoothDevice {
    static func from(statusString: String) -> CBPeripheralState {
        switch statusString {
        case "Connected": return .connected
        case "Connecting": return .connecting
        case "Disconnected": return .disconnected
        case "Disconnecting": return .disconnecting
        default: return .disconnected
        }
    }
}
