import WidgetKit
import SwiftUI

struct FarmConditionsWidget: Widget {
    let kind: String = "FarmConditionsWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                FarmConditionsWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                FarmConditionsWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Farm Conditions")
        .description("Monitor your farm's soil moisture, temperature, and growing conditions at a glance.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

#Preview(as: .systemSmall) {
    FarmConditionsWidget()
} timeline: {
    SimpleEntry(date: .now, farmConditions: .sampleData)
    SimpleEntry(date: .now.addingTimeInterval(300), farmConditions: .sampleData)
}