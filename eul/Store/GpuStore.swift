//
//  GpuStore.swift
//  eul
//
//  Created by Gao Sun on 2021/1/23.
//  Copyright © 2021 Gao Sun. All rights reserved.
//

import Foundation
import SharedLibrary
import WidgetKit

class GpuStore: ObservableObject, Refreshable {
    @Published var gpus = [GPU]()
    @Published var gpuStatistics = [GPU.Statistic]()
    @Published var usageHistory: [Double] = []

    var usageAverage: Double? {
        let stats = gpus.compactMap { getStatustic(for: $0) }
        guard stats.count > 0 else {
            return nil
        }
        return Double(stats.reduce(0) { $0 + $1.usagePercentage }) / Double(stats.count)
    }

    var usageAverageString: String? {
        guard let average = usageAverage else {
            return nil
        }
        return "\(String(format: "%.0f", average))%"
    }

    var temperatureAverage: Double? {
        let temps = gpus.compactMap { getStatustic(for: $0)?.temperature }
        guard temps.count > 0 else {
            return nil
        }
        return temps.reduce(0) { $0 + $1 } / Double(temps.count)
    }

    func getStatustic(for gpu: GPU) -> GPU.Statistic? {
        gpuStatistics.first {
            let deviceIdLower = gpu.deviceId.deletingPrefix("0x").lowercased()
            let pciMatchLower = $0.pciMatch.lowercased()

            let isAppleSilicon = deviceIdLower.contains("apple") || deviceIdLower.contains(" m")

            if isAppleSilicon {
                return pciMatchLower == "apple"
            } else {
                return pciMatchLower.contains(deviceIdLower)
            }
        }
    }

    func writeToContainer() {
        Container.set(GpuEntry(
            temp: temperatureAverage,
            usagePercentage: usageAverage
        ))
        WidgetCenter.shared.reloadTimelines(ofKind: GpuEntry.kind)
    }

    @objc func refresh() {
        gpuStatistics = GPU.getInfo() ?? []
        usageHistory = (usageHistory + [usageAverage ?? 0]).suffix(LineChart.defaultMaxPointCount)
        writeToContainer()
    }

    init() {
        gpus = GPU.getGPUs() ?? []
        initObserver(for: .StoreShouldRefresh)
    }
}
