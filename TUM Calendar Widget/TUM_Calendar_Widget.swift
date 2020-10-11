//
//  TUM_Calendar_Widget.swift
//  TUM Calendar Widget
//
//  Created by Robert Jandow on 12.10.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    // Function for the preview
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    // Function displayed until correct data is fetched
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    // Called when the widget is updates
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

// Data for the widget
struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct TUM_Calendar_WidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Text(entry.date, style: .time)
    }
}

@main
struct TUM_Calendar_Widget: Widget {
    let kind: String = "TUM_Calendar_Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TUM_Calendar_WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct TUM_Calendar_Widget_Previews: PreviewProvider {
    static var previews: some View {
        TUM_Calendar_WidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
