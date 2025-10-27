//
//  BluetoothDeviceDetailView.swift
//  NetworkScannerP
//
//  Created by Marwa Awad on 28.10.2025.
//

import Foundation
import SwiftUI



struct BluetoothDeviceDetailView: View {
    let device: BluetoothDevice
    
    var body: some View {
        List {
            Section("Device Information") {
                DetailRow(title: "Name", value: device.name ?? "Unknown")
                DetailRow(title: "UUID", value: device.uuid)
                DetailRow(title: "RSSI", value: "\(device.rssi) dBm")
                DetailRow(title: "Status", value: device.status.displayName)
            }
        }
        .navigationTitle("Bluetooth Device")
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.trailing)
        }
    }
}
