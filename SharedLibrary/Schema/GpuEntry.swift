//
//  GpuEntry.swift
//  eul
//
//  GPU widget entry for WidgetKit
//

import Foundation

@available(macOSApplicationExtension 11, *)
public struct GpuEntry: SharedWidgetEntry {
    public init(date: Date = Date(), outdated: Bool = false, temp: Double? = nil, usagePercentage: Double? = nil) {
        self.date = date
        self.outdated = outdated
        self.temp = temp
        self.usagePercentage = usagePercentage
    }

    public init(date: Date, outdated: Bool) {
        self.date = date
        self.outdated = outdated
    }

    public static let containerKey = "GpuEntry"
    public static let kind = "GPUWidget"
    public static let sample = GpuEntry(temp: 45, usagePercentage: 32)

    public var date = Date()
    public var outdated = false
    public var temp: Double?
    public var usagePercentage: Double?

    public var usageString: String {
        guard isValid, let usagePercentage = usagePercentage else {
            return "N/A"
        }
        return String(format: "%.0f%%", usagePercentage)
    }
}
