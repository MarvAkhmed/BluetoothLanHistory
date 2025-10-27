//
//  LanHistoryView.swift
//  NetworkScannerP
//
//  Created by Marwa Awad on 28.10.2025.
//

import SwiftUI

struct LanHistoryView: View {
    @StateObject var viewModel: LanScanViewModel

    @State private var sessions: [ScanSessionLocal] = []

    var body: some View {
        List(sessions) { session in
            Section(header: Text(session.date, style: .date)) {
                ForEach(session.devices) { device in
                    VStack(alignment: .leading) {
                        Text(device.name ?? "Unknown")
                        Text(device.ipAddress ?? "No IP")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .task {
            sessions = await viewModel.fetchLanScanHistory()
        }
        .navigationTitle("LAN Scan History")
    }
}
