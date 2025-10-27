//
//  ScanHistoryView.swift
//  NetworkScannerP
//
//  Created by Marwa Awad on 27.10.2025.
//

import SwiftUI

struct BluetoothHistoryView: View {
    @StateObject var viewModel: BluetoothViewModel
    @State private var sessions: [ScanSessionLocal] = []

    var body: some View {
        List(sessions) { session in
            Section(header: Text(session.date, style: .date)) {
                ForEach(session.devices) { device in
                    NavigationLink {
                        BluetoothDeviceDetailView(device: BluetoothDevice(
                            name: device.name,
                            uuid: device.uuid ?? "no uuid found",
                            rssi: Int(device.rssi),
                            status: BluetoothDevice.from(statusString: device.status ?? "Unknown")
                        ))
                    } label: {
                        VStack(alignment: .leading) {
                            Text(device.name ?? "Unknown Device")
                            Text(device.uuid ?? "No UUID")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text("RSSI: \(device.rssi)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            if let status = device.status {
                                Text("Status: \(status)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
        }
        .task {
            sessions = await viewModel.fetchBluetoothScanHistory()
        }
        .navigationTitle("Bluetooth Scan History")
    }
}
