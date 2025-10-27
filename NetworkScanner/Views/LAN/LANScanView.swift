//
//  LanScanView.swift
//  NetworkScannerP
//
//  Created by Marwa Awad on 27.10.2025.
//

import SwiftUI

struct LanScanView: View {
    @StateObject private var viewModel = LanScanViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                statusSection
                showProgress
                scanControlSection
                devicesSection
            }
            .padding(.vertical)
        }
        .navigationTitle("LAN Scan")
        .navigationBarTitleDisplayMode(.large)
        .background(Color(.systemGroupedBackground))
        .alert("Scan Complete", isPresented: $viewModel.showCompletionAlert) {
            Button("OK", role: .cancel) {
                viewModel.dismissCompletionAlert()
            }
        } message: {
            Text("Found \(viewModel.devices.count) device\(viewModel.devices.count == 1 ? "" : "s") on your network")
        }
    }
    
    // MARK: - Progress Section
    @ViewBuilder
    private var showProgress: some View {
        if viewModel.isScanning {
            VStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Scanning...")
                            .font(.headline)
                        Spacer()
                        Text("\(Int(viewModel.scanProgress * 100))%")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 6)
                            .frame(height: 12)
                            .foregroundColor(Color(.systemGray5))
                        
                        RoundedRectangle(cornerRadius: 6)
                            .frame(width: CGFloat(viewModel.scanProgress) * (UIScreen.main.bounds.width - 64), height: 12)
                            .foregroundColor(.blue)
                            .animation(.easeInOut(duration: 0.3), value: viewModel.scanProgress)
                    }
                }
                
                HStack(spacing: 6) {
                    Image(systemName: "clock")
                    Text("Time remaining: \(viewModel.timeRemaining)s")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
            .padding(.horizontal)
        }
    }
    
    // MARK: - Status Section
    @ViewBuilder
    private var statusSection: some View {
        VStack(spacing: 0) {
            if let error = viewModel.errorMessage {
                errorView(error)
            }
            
            if !viewModel.devices.isEmpty {
                deviceCountView
            }
        }
    }
    
    // MARK: - Scan Control
    @ViewBuilder
    private var scanControlSection: some View {
        VStack(spacing: 16) {
            Button(viewModel.isScanning ? "Stop Scan" : "Start Scan") {
                if viewModel.isScanning {
                    viewModel.stopScan()
                } else {
                    viewModel.startScan(for: 15) // Stops automatically after 15 sec
                }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(viewModel.errorMessage != nil)
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal)
    }
    
    // MARK: - Devices List
    @ViewBuilder
    private var devicesSection: some View {
        if !viewModel.devices.isEmpty {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.devices) { device in
                    LANScanCell(device: device)
                }
            }
            .animation(.easeInOut, value: viewModel.devices.count)
        } else if !viewModel.isScanning && viewModel.errorMessage == nil {
            emptyStateView
        }
    }
    
    // MARK: - Empty State
    @ViewBuilder
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 50))
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                Text("No Devices Found")
                    .font(.headline)
                
                Text("Start scanning to discover devices on your Wi-Fi network")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
    
    // MARK: - Device Count
    @ViewBuilder
    private var deviceCountView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Discovered Devices")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("\(viewModel.devices.count) device\(viewModel.devices.count == 1 ? "" : "s") found")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Circle()
                .fill(Color.blue)
                .frame(width: 8, height: 8)
                .opacity(viewModel.isScanning ? 1 : 0.3)
        }
        .padding(.horizontal)
    }
    
    // MARK: - Error View
    @ViewBuilder
    private func errorView(_ error: String) -> some View {
        VStack(spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.orange)
                    .imageScale(.large)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Scan Error")
                        .font(.headline)
                    Text(error)
                        .font(.body)
                        .foregroundColor(.primary)
                }
                
                Spacer()
            }
            
            Button(action: {
                viewModel.startScan()
            }) {
                Text("Try Again")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.orange)
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .cornerRadius(12)
        .padding(.horizontal)
    }

}

#Preview {
    LanScanView()
}
