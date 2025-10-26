//
//  BluetoothDevice.swift
//  NetworkScanner
//
//  Created by Marwa Awad on 26.10.2025.
//

import CoreBluetooth

struct BluetoothDevice: Identifiable {
    
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
