//
//  DiskWidget.swift
//  DiskWidget
//
//  Disk space widget showing free/used/total storage
//

import Localize_Swift
import SharedLibrary
import SwiftUI
import WidgetKit

struct Provider: StandardProvider {
    typealias WidgetEntry = DiskEntry
}

struct DiskWidgetEntryView: View {
    var entry: Provider.Entry

    var usageRatio: CGFloat {
        guard entry.totalBytes > 0 else { return 0 }
        return CGFloat(entry.usedBytes) / CGFloat(entry.totalBytes)
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer()

                HStack(alignment: .top) {
                    Image(systemName: "internaldrive")
                        .font(.system(size: 12, weight: .medium))
                    Spacer()
                    Text(entry.usedString + " " + "disk.used".localized())
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.secondary)
                }

                Spacer().frame(height: 8)

                HStack {
                    Text(entry.freeString)
                        .font(.system(size: 32, weight: .heavy))
                        .minimumScaleFactor(0.4)
                        .lineLimit(1)
                    Spacer()
                }

                Text("disk.free".localized())
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Spacer().frame(height: 12)

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color.primary.opacity(0.08))
                            .frame(height: 5)
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color.primary.opacity(0.5))
                            .frame(width: max(0, geo.size.width * usageRatio), height: 5)
                    }
                }
                .frame(height: 5)

                Spacer().frame(height: 6)

                HStack {
                    Text(entry.totalString)
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.secondary)
                    Spacer()
                }

                Spacer()
            }
            .padding(4)

            if !entry.isValid {
                WidgetNotAvailbleView(text: "widget.not_available".localized())
            }
        }
    }
}

struct DiskWidget: Widget {
    let kind: String = DiskEntry.kind

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            DiskWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("widget.disk.title".localized())
        .description("widget.disk.description".localized())
        .supportedFamilies([.systemSmall])
    }
}
