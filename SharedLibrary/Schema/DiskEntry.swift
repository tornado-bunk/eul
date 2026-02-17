//
//  DiskEntry.swift
//  eul
//
//  Disk widget entry for WidgetKit
//

import Foundation

@available(macOSApplicationExtension 11, *)
public struct DiskEntry: SharedWidgetEntry {
    public init(date: Date = Date(), outdated: Bool = false, totalBytes: UInt64 = 0, freeBytes: UInt64 = 0) {
        self.date = date
        self.outdated = outdated
        self.totalBytes = totalBytes
        self.freeBytes = freeBytes
    }

    public init(date: Date, outdated: Bool) {
        self.date = date
        self.outdated = outdated
    }

    public static let containerKey = "DiskEntry"
    public static let kind = "DiskWidget"
    public static let sample = DiskEntry(totalBytes: 1_000_000_000_000, freeBytes: 450_000_000_000)

    public var date = Date()
    public var outdated = false
    public var totalBytes: UInt64 = 0
    public var freeBytes: UInt64 = 0

    public var usedBytes: UInt64 {
        totalBytes > freeBytes ? totalBytes - freeBytes : 0
    }

    public var freeString: String {
        guard isValid, totalBytes > 0 else { return "N/A" }
        return ByteUnit(freeBytes, kilo: 1000).readable
    }

    public var usedString: String {
        guard isValid, totalBytes > 0 else { return "N/A" }
        return ByteUnit(usedBytes, kilo: 1000).readable
    }

    public var totalString: String {
        guard isValid, totalBytes > 0 else { return "N/A" }
        let gb = Double(totalBytes) / 1_000_000_000
        if gb >= 1000 {
            return String(format: "%.0f TB", gb / 1000)
        }
        return String(format: "%.0f GB", gb)
    }

    public var usagePercentage: Double {
        guard totalBytes > 0 else { return 0 }
        return Double(usedBytes) / Double(totalBytes) * 100
    }

    public var freePercentage: Double {
        guard totalBytes > 0 else { return 0 }
        return Double(freeBytes) / Double(totalBytes) * 100
    }
}
