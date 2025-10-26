//
//  BluetoothScanCell.swift
//  NetworkScanner
//
//  Created by Marwa Awad on 26.10.2025.
//

import SwiftUI
import CoreBluetooth

struct BluetoothScanCell: View {
    private var viewModel = BluetoothViewModel()
    private let index: Int
    
    init(viewModel: BluetoothViewModel, index: Int) {
        self.viewModel = viewModel
        self.index = index
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            headerSection
            signalSection
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
    
    @ViewBuilder
    private var headerSection: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.deviceName(at: index))
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(viewModel.deviceUUID(at: index))
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .textSelection(.enabled)
            }
            
            Spacer()
            
            statusBadge
        }
    }
    
    @ViewBuilder
    private var signalSection: some View {
        HStack {
            Image(systemName: "wave.3.right")
                .foregroundColor(.blue)
            
            Text("Signal: \(viewModel.deviceRSSI(at: index)) dBm")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Spacer()
            
            signalIndicator
        }
    }
    
    @ViewBuilder
    private var statusBadge: some View {
        Text(viewModel.deviceStatus(at: index))
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(deviceStatusColor(at: index).opacity(0.2))
            .foregroundColor(deviceStatusColor(at: index))
            .cornerRadius(6)
    }
    
    @ViewBuilder
    private var signalIndicator: some View {
        HStack(spacing: 2) {
            ForEach(0..<5, id: \.self) { barIndex in
                Rectangle()
                    .fill(signalStrengthColor(at: index).opacity(barIndex < viewModel.signalBars(at: index) ? 1 : 0.3))
                    .frame(width: 3, height: CGFloat(barIndex + 2) * 3)
            }
        }
    }
}
 
// MARK: - View Helpers
extension BluetoothScanCell {
   private func deviceStatusColor(at index: Int) -> Color {
       guard viewModel.devices.indices.contains(index) else { return .secondary }
        switch viewModel.devices[index].status {
        case .connected: return .green
        case .connecting: return .orange
        case .disconnected: return .gray
        case .disconnecting: return .orange
        @unknown default: return .secondary
        }
    }
    
    private func signalStrengthColor(at index: Int) -> Color {
        guard viewModel.devices.indices.contains(index) else { return .gray }
        let rssi = viewModel.devices[index].rssi
        if rssi >= -50 { return .green }
        else if rssi >= -70 { return .yellow }
        else { return .red }
    }
}
