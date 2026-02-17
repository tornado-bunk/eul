//
//  GPUWidget.swift
//  GPUWidget
//
//  GPU usage widget
//

import Localize_Swift
import SharedLibrary
import SwiftUI
import WidgetKit

struct Provider: StandardProvider {
    typealias WidgetEntry = GpuEntry
}

struct GPUWidgetEntryView: View {
    var preferenceEntry = Container.get(PreferenceEntry.self) ?? PreferenceEntry()
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            VStack(spacing: 8) {
                Spacer()
                HStack(alignment: .top) {
                    Image("GPU")
                        .resizable()
                        .frame(width: 12, height: 12)
                    Spacer()
                    if let temp = entry.temp {
                        Text(temp.formatTemp(unit: preferenceEntry.temperatureUnit))
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.secondary)
                    }
                }
                HStack {
                    Text(entry.usageString)
                        .widgetTitle()
                    Spacer()
                }
                .padding(.bottom, 24)
                HStack {
                    if let temp = entry.temp {
                        WidgetSectionView(title: "gpu.temperature".localized(), value: temp.formatTemp(unit: preferenceEntry.temperatureUnit))
                    }
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

struct GPUWidget: Widget {
    let kind: String = GpuEntry.kind

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            GPUWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("widget.gpu.title".localized())
        .description("widget.gpu.description".localized())
        .supportedFamilies([.systemSmall])
    }
}
