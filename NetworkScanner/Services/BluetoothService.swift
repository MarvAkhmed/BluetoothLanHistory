//
//  BluetoothService.swift
//  NetworkScanner
//
//  Created by Marwa Awad on 26.10.2025.
//

import CoreBluetooth
import Combine

// MARK: - Protocol for Dependency Injection
protocol BluetoothServicing: ObservableObject {
    var discoveredDevices: [BluetoothDevice] { get }
    var isScanning: Bool { get }
    var errorMessage: String? { get }
    var scanProgress: Double { get }
    var timeRemaining: Int { get }
    
    func startScanning(for seconds: Int)
    func stopScanning()
}


class BluetoothService: NSObject, BluetoothServicing {
    // MARK: - Published Properties
    @Published private(set) var discoveredDevices: [BluetoothDevice] = []
    @Published private(set) var isScanning: Bool = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var scanProgress: Double = 0.0
    @Published private(set) var timeRemaining: Int = 15
    
    // MARK: - Private Properties
    private var centralManager: CBCentralManager?
    private var scanTimer: Timer?
    private var totalScanTime: Int = 15
    
    // MARK: - Initializer
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    // MARK: - Bluetooth Operations
    func startScanning(for seconds: Int) {
        guard let centralManager = centralManager, centralManager.state == .poweredOn else {
            errorMessage = "Bluetooth is not available"
            return
        }
        
        resetScanState()
        totalScanTime = seconds
        isScanning = true
        
        centralManager.scanForPeripherals(withServices: nil)
        createScanTimer()
    }
    
    func stopScanning() {
        centralManager?.stopScan()
        scanTimer?.invalidate()
        scanTimer = nil
        isScanning = false
    }
    
    // MARK: - Private Methods
    private func resetScanState() {
        discoveredDevices.removeAll()
        errorMessage = nil
        scanProgress = 0.0
        timeRemaining = totalScanTime
    }
    
    private func createScanTimer() {
        scanTimer?.invalidate()
        
        scanTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.timeRemaining -= 1
            let elapsedTime = Double(self.totalScanTime - self.timeRemaining)
            self.scanProgress = max(0.0, min(1.0, elapsedTime / Double(self.totalScanTime)))
            if self.timeRemaining <= 0 { self.stopScanning() }
        }
    }
    
    private func updateDiscoveredDevice(_ device: BluetoothDevice) {
        if let index = discoveredDevices.firstIndex(where: { $0.uuid == device.uuid }) {
            discoveredDevices[index] = device
        } else {
            discoveredDevices.append(device)
        }
    }
}

// MARK: - CBCentralManagerDelegate
extension BluetoothService: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            errorMessage = nil
        case .poweredOff:
            errorMessage = "Bluetooth is turned off"
            stopScanning()
        case .unauthorized:
            errorMessage = "Bluetooth permission denied"
            stopScanning()
        case .unsupported:
            errorMessage = "Bluetooth not supported"
            stopScanning()
        default:
            break
        }
    }
    
    func centralManager(_ central: CBCentralManager,
                       didDiscover peripheral: CBPeripheral,
                       advertisementData: [String: Any],
                       rssi RSSI: NSNumber) {
        let device = BluetoothDevice(
            name: peripheral.name ?? advertisementData[CBAdvertisementDataLocalNameKey] as? String,
            uuid: peripheral.identifier.uuidString,
            rssi: RSSI.intValue,
            status: peripheral.state
        )
        
        Task {
            updateDiscoveredDevice(device)
        }
    }
}
