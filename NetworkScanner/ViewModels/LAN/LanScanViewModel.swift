//
//  LanScanViewModel.swift
//  NetworkScannerP
//
//  Created by Marwa Awad on 27.10.2025.
//
import Foundation
import Combine

final class LanScanViewModel: ObservableObject {

    @Published private(set) var devices: [LanDevice] = []
    @Published var isScanning: Bool = false
    @Published var errorMessage: String?
    @Published var showCompletionAlert: Bool = false
    @Published var timeRemaining: Int = 0
    @Published var scanProgress: Double = 0.0

    private var timer: Timer?
    private let service: LanScanService
    private let coreDataService: ScanDataServiceProtocol
    
    init(service: LanScanService = LanScanService(),
         coreDataService: ScanDataServiceProtocol) {

        self.service = service
        self.coreDataService = coreDataService
        self.service.delegate = self
    }


    // MARK: - Public Methods

    func startScan(for duration: Int = 15) {
        guard !isScanning else { return }

        devices.removeAll()
        scanProgress = 0.0
        timeRemaining = duration
        errorMessage = nil
        showCompletionAlert = false
        isScanning = true

        startProgressTimer(totalDuration: duration)

        service.startScan()
    }

    func stopScan() {
        service.stopScan()
        Task {
            await finishScanning()
        }
       
    }

    func dismissCompletionAlert() {
        showCompletionAlert = false
    }
}

// MARK: - Delegate
extension LanScanViewModel: LanScanServiceDelegate {
    func didUpdateProgress(_ progress: Double) {
        DispatchQueue.main.async { [weak self] in
            self?.scanProgress = min(max(progress, 0), 1)
        }
    }

    func didFind(device: LanDevice) {
        DispatchQueue.main.async { [weak self] in
            self?.addDevice(device)
        }
    }

    func didFinishScanning() {
        Task{ await  finishScanning() }
    }

    func didFailWithError(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.stopScan()
            self.timer?.invalidate()
            self.timer = nil
            self.errorMessage = error.localizedDescription
        }
    }
}

// MARK: - Timer & Progress
private extension LanScanViewModel {
    func startProgressTimer(totalDuration: Int) {
        timer?.invalidate()
        let interval = 0.1
        var elapsed: Double = 0
        timeRemaining = totalDuration
        
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] t in
            guard let self = self else { return }
            elapsed += interval
            self.timeRemaining = max(totalDuration - Int(elapsed.rounded()), 0)
            self.scanProgress = min(elapsed / Double(totalDuration), 1.0)
            if self.timeRemaining <= 0 {
                t.invalidate()
                self.service.finishScan()
            }
        }
    }
    
    func addDevice(_ device: LanDevice) {
        if !devices.contains(device) {
            devices.append(device)
        }
    }
}

//MARK: -  Core data
extension LanScanViewModel {
    private func finishScanning() async {
        self.isScanning = false
        self.timer?.invalidate()
        self.timer = nil
        self.scanProgress = 1.0
        self.showCompletionAlert = true
        
        
        guard !devices.isEmpty else {  return  }
        let localDevices = devices.map { lan in
            DeviceDataLocal(
                id: UUID(),
                name: lan.name,
                type: DeviceType.lan.rawValue, 
                uuid: nil,
                ipAddress: lan.ipAddress,
                macAddress: lan.macAddress,
                rssi: 0,
                status: nil
            )
        }
        
        Task.detached { [localDevices, coreDataService] in
            do {
                try await coreDataService.saveScanSession(devices: localDevices, sessionType: DeviceType.lan.rawValue)
            }
        }
    }
    
    
    func fetchLanScanHistory() async -> [ScanSessionLocal] {
        do {
            let sessions = try await coreDataService.fetchScanSessions(ofType: DeviceType.lan.rawValue)
            return sessions.filter { !$0.devices.isEmpty }
        } catch {
            print("Failed to fetch LAN scan history: \(error)")
            return []
        }
    }
}
