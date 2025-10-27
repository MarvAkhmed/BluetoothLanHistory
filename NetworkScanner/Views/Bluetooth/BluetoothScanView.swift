//
//  BluetoothScanView.swift
//  NetworkScanner
//
//  Created by Marwa Awad on 26.10.2025.
//

import SwiftUI
import CoreBluetooth

struct BluetoothScanView: View {
    @StateObject private var viewModel = BluetoothViewModel()
    
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
        .navigationTitle("Bluetooth Scan")
        .navigationBarTitleDisplayMode(.large)
        .background(Color(.systemGroupedBackground))
        .alert("Scan Complete",
               isPresented: $viewModel.showCompletionAlert) {
            Button("OK", role: .cancel) {
                viewModel.dismissCompletionAlert()
            }
        } message: {
            Text("Found \(viewModel.devices.count) device\(viewModel.devices.count == 1 ? "" : "s")")
        }
    }
    
    @ViewBuilder
    private var showProgress: some View {
        if viewModel.isScanning {
            ZStack {
                Circle()
                    .stroke(Color(.systemGray5), lineWidth: 8)
                    .frame(width: 120, height: 120)
                
                Circle()
                    .trim(from: 0, to: CGFloat(viewModel.scanProgress))
                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .frame(width: 120, height: 120)
                    .animation(.easeInOut(duration: 0.2), value: viewModel.scanProgress)
                
                ScanningAnimationView()
                    .frame(width: 80, height: 80)
            }
            .padding(.vertical)
            
            // Time remaining
            HStack {
                Image(systemName: "clock")
                Text("Time remaining: \(viewModel.timeRemaining)s")
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
    }
    
    
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
    
    @ViewBuilder
    private var scanControlSection: some View {
        VStack(spacing: 16) {
            Button(viewModel.isScanning ? "Stop Scanning" : "Start Scan") {
                if viewModel.isScanning {
                    viewModel.stopScanning()
                } else {
                    viewModel.startScanning()
                    
                }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(viewModel.errorMessage != nil)
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private var devicesSection: some View {
        if !viewModel.devices.isEmpty {
            LazyVStack(spacing: 12) {
                ForEach(0..<viewModel.deviceCount, id: \.self) { index in
                    NavigationLink {
                        BluetoothDeviceDetailView(device: viewModel.devices[index])
                    } label: {
                        BluetoothScanCell(viewModel: viewModel, index: index)
                            .padding(.horizontal)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .animation(.easeInOut, value: viewModel.devices.count)
        } else if !viewModel.isScanning && viewModel.errorMessage == nil {
            emptyStateView
        }
    }
}

//MARK: - Status Section Components
extension BluetoothScanView {
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
    

    @ViewBuilder
       private var emptyStateView: some View {
           VStack(spacing: 16) {
               Image(systemName: "antenna.radiowaves.left.and.right")
                   .font(.system(size: 50))
                   .foregroundColor(.secondary)
               
               VStack(spacing: 8) {
                   Text("No Devices Found")
                       .font(.headline)
                   
                   Text("Start scanning to discover nearby Bluetooth devices")
                       .font(.body)
                       .foregroundColor(.secondary)
                       .multilineTextAlignment(.center)
               }
           }
           .frame(maxWidth: .infinity)
           .padding(.vertical, 40)
       }

    
    @ViewBuilder
    private func errorView(_ error: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.orange)
                .imageScale(.large)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Bluetooth Unavailable")
                    .font(.headline)
                Text(error)
                    .font(.body)
                    .foregroundColor(.primary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
}

#Preview {
    BluetoothScanView()
}
