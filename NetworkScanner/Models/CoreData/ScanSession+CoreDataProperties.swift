//
//  ScanSession+CoreDataProperties.swift
//  NetworkScannerP
//
//  Created by Marwa Awad on 28.10.2025.
//
//

public import Foundation
public import CoreData


public typealias ScanSessionCoreDataPropertiesSet = NSSet

extension ScanSession {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ScanSession> {
        return NSFetchRequest<ScanSession>(entityName: "ScanSession")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var sessionType: String?
    @NSManaged public var device: NSSet?

}

// MARK: Generated accessors for device
extension ScanSession {

    @objc(addDeviceObject:)
    @NSManaged public func addToDevice(_ value: Device)

    @objc(removeDeviceObject:)
    @NSManaged public func removeFromDevice(_ value: Device)

    @objc(addDevice:)
    @NSManaged public func addToDevice(_ values: NSSet)

    @objc(removeDevice:)
    @NSManaged public func removeFromDevice(_ values: NSSet)

}

extension ScanSession : Identifiable {

}
