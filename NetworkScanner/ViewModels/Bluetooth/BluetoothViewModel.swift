//
//  BluetoothViewModel.swift
//  NetworkScanner
//
//  Created by Marwa Awad on 26.10.2025.
//

import Combine
import CoreBluetooth

class BluetoothViewModel: ObservableObject {
    
    // MARK: - Dependencies
    private let bluetoothService: any BluetoothServicing
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Private Published Properties
    @Published private var _devices: [BluetoothDevice] = []
    @Published private var _isScanning: Bool = false
    @Published private var _errorMessage: String?
    @Published private var _scanProgress: Double = 0.0
    @Published private var _timeRemaining: Int = 15
    @Published var showCompletionAlert: Bool = false
    
    // MARK: - Public Getters
    var devices: [BluetoothDevice] { _devices }
    var isScanning: Bool { _isScanning }
    var errorMessage: String? { _errorMessage }
    var scanProgress: Double { _scanProgress }
    var timeRemaining: Int { _timeRemaining }
    
    // MARK: - Computed Properties
    var deviceCount: Int { _devices.count }
    var hasDevices: Bool { !_devices.isEmpty }
    var hasError: Bool { _errorMessage != nil }
    var isScanComplete: Bool { _timeRemaining == 0 && !_isScanning }
    var progressPercentage: Int { Int(_scanProgress * 100) }
    
    // MARK: - Device-specific Getters for Cells
    func deviceName(at index: Int) -> String {
        guard _devices.indices.contains(index) else { return "Unknown Device" }
        return _devices[index].name ?? "Unknown Device"
    }
    
    func deviceUUID(at index: Int) -> String {
        guard _devices.indices.contains(index) else { return "N/A" }
        return _devices[index].uuid
    }
    
    func deviceRSSI(at index: Int) -> Int {
        guard _devices.indices.contains(index) else { return 0 }
        return _devices[index].rssi
    }
    
    func deviceStatus(at index: Int) -> String {
        guard _devices.indices.contains(index) else { return "Unknown" }
        return _devices[index].status.displayName
    }

    
    func signalBars(at index: Int) -> Int {
        guard _devices.indices.contains(index) else { return 0 }
        let rssi = _devices[index].rssi
        if rssi >= -50 { return 5 }
        else if rssi >= -60 { return 4 }
        else if rssi >= -70 { return 3 }
        else if rssi >= -80 { return 2 }
        else { return 1 }
    }
    
    // MARK: - Constants
    private let scanDuration: Int = 15
    
    // MARK: - Initializer
    init(bluetoothService: any BluetoothServicing = BluetoothService()) {
        self.bluetoothService = bluetoothService
        setupBindings()
    }
    
    // MARK: - General Logic
    func startScanning() {
        bluetoothService.startScanning(for: scanDuration)
    }
    
    func stopScanning() {
        bluetoothService.stopScanning()
    }
}

// MARK: - Private Methods
private extension BluetoothViewModel {
    private func setupBindings() {
        if let service = bluetoothService as? BluetoothService {
            setupConcreteBindings(with: service)
        } else {
            setupGenericBindings()
        }
    }
    
    private func setupConcreteBindings(with service: BluetoothService) {
        service.$discoveredDevices
            .receive(on: DispatchQueue.main)
            .assign(to: \._devices, on: self)
            .store(in: &cancellables)
            
        service.$isScanning
            .receive(on: DispatchQueue.main)
            .assign(to: \._isScanning, on: self)
            .store(in: &cancellables)
            
        service.$errorMessage
            .receive(on: DispatchQueue.main)
            .assign(to: \._errorMessage, on: self)
            .store(in: &cancellables)
            
        service.$scanProgress
            .receive(on: DispatchQueue.main)
            .assign(to: \._scanProgress, on: self)
            .store(in: &cancellables)
            
        service.$timeRemaining
            .receive(on: DispatchQueue.main)
            .assign(to: \._timeRemaining, on: self)
            .store(in: &cancellables)
            
        setupScanCompletionBinding(with: service)
    }
    
    private func setupGenericBindings() {
        Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateFromService()
            }
            .store(in: &cancellables)
    }
    
    private func setupScanCompletionBinding(with service: BluetoothService) {
        service.$isScanning
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isScanning in
                guard let self = self else { return }
                
                if !isScanning && self._timeRemaining == 0 {
                    self.showCompletionAlert = true
                }
            }
            .store(in: &cancellables)
    }
    
    private func updateFromService() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self._devices = self.bluetoothService.discoveredDevices
            self._isScanning = self.bluetoothService.isScanning
            self._errorMessage = self.bluetoothService.errorMessage
            self._scanProgress = self.bluetoothService.scanProgress
            self._timeRemaining = self.bluetoothService.timeRemaining
        }
    }
}
