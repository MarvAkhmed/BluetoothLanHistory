//
//  LanDeviceDetailView.swift
//  NetworkScannerP
//
//  Created by Marwa Awad on 28.10.2025.
//

import Foundation
import SwiftUI

struct LanDeviceDetailView: View {
    let device: LanDevice
    
    var body: some View {
        List {
            Section("Network Information") {
                DetailRow(title: "Name", value: device.displayName)
                DetailRow(title: "IP Address", value: device.ipAddress)
                DetailRow(title: "MAC Address", value: device.displayMAC)
            }
        }
        .navigationTitle("Network Device")
    }
}
