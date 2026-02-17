//
//  DiskStore.swift
//  eul
//
//  Created by Gao Sun on 2020/11/1.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation
import SharedLibrary
import WidgetKit

class DiskStore: ObservableObject, Refreshable {
    var config: EulComponentConfig {
        SharedStore.componentConfig[EulComponent.Disk]
    }

    @Published var list: DiskList?

    var selectedDisk: DiskList.Disk? {
        guard config.diskSelection != "" else {
            return nil
        }
        return list?.disks.filter { $0.name == config.diskSelection }.first
    }

    var ceilingBytes: UInt64? {
        selectedDisk?.size ?? list?.disks.reduce(0) { $0 + $1.size }
    }

    var freeBytes: UInt64? {
        selectedDisk?.freeSize ?? list?.disks.reduce(0) { $0 + $1.freeSize }
    }

    var usageString: String {
        guard let ceiling = ceilingBytes, let free = freeBytes else {
            return "N/A"
        }
        return ByteUnit(ceiling - free, kilo: 1000).readable
    }

    var usagePercentageString: String {
        guard let ceiling = ceilingBytes, let free = freeBytes else {
            return "N/A"
        }
        return (Double(ceiling - free) / Double(ceiling)).percentageString
    }

    var freeString: String {
        guard let free = freeBytes else {
            return "N/A"
        }
        return ByteUnit(free, kilo: 1000).readable
    }

    var totalString: String {
        guard let ceiling = ceilingBytes else {
            return "N/A"
        }
        return ByteUnit(ceiling, kilo: 1000).readable
    }

    func writeToContainer() {
        // Use root volume (/) for the widget instead of summing all volumes
        let rootTotal: UInt64
        let rootFree: UInt64
        if let attrs = try? FileManager.default.attributesOfFileSystem(forPath: "/"),
           let size = attrs[FileAttributeKey.systemSize] as? UInt64,
           let free = attrs[FileAttributeKey.systemFreeSize] as? UInt64
        {
            rootTotal = size
            rootFree = free
        } else {
            rootTotal = ceilingBytes ?? 0
            rootFree = freeBytes ?? 0
        }
        Container.set(DiskEntry(
            totalBytes: rootTotal,
            freeBytes: rootFree
        ))
        WidgetCenter.shared.reloadTimelines(ofKind: DiskEntry.kind)
    }

    @objc func refresh() {
        guard let volumes = (try? FileManager.default.contentsOfDirectory(atPath: DiskList.volumesPath)) else {
            list = nil
            return
        }

        list = DiskList(disks: volumes.compactMap {
            if $0.starts(with: ".") || $0.contains("com.apple") { return nil }

            let path = DiskList.pathForName($0)
            let url = URL(fileURLWithPath: path)

            guard
                let attributes = try? FileManager.default.attributesOfFileSystem(forPath: path),
                let size = attributes[FileAttributeKey.systemSize] as? UInt64,
                let freeSize = attributes[FileAttributeKey.systemFreeSize] as? UInt64
            else {
                return nil
            }

            let isEjectable = !((try? url.resourceValues(forKeys: [.volumeIsInternalKey]))?.volumeIsInternal ?? false)

            return DiskList.Disk(
                name: $0,
                size: size,
                freeSize: freeSize,
                isEjectable: isEjectable
            )
        })

        writeToContainer()
    }

    init() {
        initObserver(for: .StoreShouldRefresh)
    }
}
