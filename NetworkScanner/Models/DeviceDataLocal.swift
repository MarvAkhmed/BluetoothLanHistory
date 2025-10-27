//
//  DeviceDataLocal.swift
//  NetworkScannerP
//
//  Created by Marwa Awad on 28.10.2025.
//

import Foundation


enum DeviceType: String {
    case lan = "LAN"
    case bluetooth = "Bluetooth"
}

struct ScanSessionLocal: Identifiable, Sendable {
    let id: UUID
    let date: Date
    let devices: [DeviceDataLocal]
}

struct DeviceDataLocal: Identifiable {
    let id: UUID
    let name: String?
    let type: String      // "Bluetooth" or "LAN"
    let uuid: String?
    let ipAddress: String?
    let macAddress: String?
    let rssi: Int16
    let status: String?
}

extension DeviceDataLocal {
    init(device: Device) {
        self.id = device.id ?? UUID()
        self.name = device.name
        self.type = device.type ?? ""
        self.uuid = device.uuid
        self.ipAddress = device.ipAddress
        self.macAddress = device.macAddress
        self.rssi = device.rssi
        self.status = device.status
    }
}

