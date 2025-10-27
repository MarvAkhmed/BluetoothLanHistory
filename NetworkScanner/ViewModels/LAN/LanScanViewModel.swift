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

    init(service: LanScanService = LanScanService()) {
        self.service = service
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
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.isScanning = false
            self.timer?.invalidate()
            self.timer = nil
            self.scanProgress = 1.0
        }
    }

    func dismissCompletionAlert() {
        showCompletionAlert = false
    }

    private func addDevice(_ device: LanDevice) {
        if !devices.contains(device) {
            devices.append(device)
        }
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
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.isScanning = false
            self.timer?.invalidate()
            self.timer = nil
            self.scanProgress = 1.0
            self.showCompletionAlert = true
        }
    }

    func didFailWithError(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.isScanning = false
            self.timer?.invalidate()
            self.timer = nil
            self.scanProgress = 1.0
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
}
