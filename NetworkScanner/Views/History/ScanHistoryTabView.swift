//
//  ScanHistoryTabView.swift
//  NetworkScannerP
//
//  Created by Marwa Awad on 27.10.2025.
//

import SwiftUI

struct ScanHistoryTabView: View {
    @State private var selectedScan = 0
    private let scanTypes = ["Bluetooth", "LAN"]
    @StateObject private var lanHistoryVM = LanScanViewModel(coreDataService: CoreDataService())
    @StateObject private var bluetoothVM = BluetoothViewModel(coreDataService: CoreDataService())

    var body: some View {
        NavigationView {
            VStack {
                Picker("Scan Type", selection: $selectedScan) {
                    ForEach(0..<scanTypes.count, id: \.self) { index in
                        Text(scanTypes[index])
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                if selectedScan == 0 {
                    BluetoothHistoryView(viewModel: bluetoothVM)
                } else if selectedScan == 1 {
                    LanHistoryView(viewModel: lanHistoryVM)
                }

                Spacer()
            }
        }
    }
}

