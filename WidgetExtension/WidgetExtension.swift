//
//  WidgetExtension.swift
//  WidgetExtension
//
//  Created by David Gunawan on 05/09/23.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    let userDefaults = UserDefaults(suiteName: "group.adeva.Tuicitis")
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), duration: readSharedData(), step: "")
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), duration: readSharedData(), step: "Wash")
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, duration: readSharedData(), step: "Wash")
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
    
    func readSharedData() -> Int {
        return userDefaults?.integer(forKey: "sharedData") ?? 0
    }
}

struct WidgetExtensionEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var widgetFamily
    
    @ViewBuilder
    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            smallWidgetView(entry)
        case .systemMedium:
            mediumWidgetView(entry)
        case .systemLarge:
            largeWidgetView(entry)
        case .systemExtraLarge:
            extraLargeWidgetView(entry)
        default:
            Text("Unsupported widget size")
        }
    }
    
    private func smallWidgetView(_ entry: Provider.Entry) -> some View {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "timer")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40)
                        .foregroundColor(.green)
                        .bold()
                    Text("Quick \nWash")
                        .foregroundStyle(.green)
                        .font(.body)
                        .bold()
                }.padding(.bottom, 10)
                HStack {
                    Text("Done in")
                        .foregroundStyle(.white)
                        .font(.caption)
                    Text("\(entry.duration) seconds")
                        .foregroundStyle(.green)
                        .font(.caption)
                }
                Spacer()
                HStack {
                    Text("\(entry.step)")
                        .foregroundStyle(.green)
                        .font(.subheadline)
                        .bold()
                    Spacer()
                    Link(destination: URL(string: "tucitis://pause")!) {
                        Label("Pause", systemImage: "pause.fill")
                            .foregroundStyle(.white)
                            .font(.caption)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                    }.background(.green)
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                }
            }.widgetBackground(.black)
    }
    
    private func mediumWidgetView(_ entry: Provider.Entry) -> some View {
        // Layout for medium widget
        smallWidgetView(entry)
    }
    
    private func largeWidgetView(_ entry: Provider.Entry) -> some View {
        // Layout for large widget
        smallWidgetView(entry)
    }
    
    private func extraLargeWidgetView(_ entry: Provider.Entry) -> some View {
        // Layout for extra-large widget (iPadOS only)
        smallWidgetView(entry)
    }
    
    
    
}

struct WidgetExtension: Widget {
    let kind: String = "WidgetExtension"
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            WidgetExtensionEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct WidgetExtension_Previews: PreviewProvider {
    static var previews: some View {
        WidgetExtensionEntryView(entry: SimpleEntry(date: Date(), duration: 5, step: "Wash"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

extension View {
    func widgetBackground(_ color: Color) -> some View {
        if #available(iOSApplicationExtension 17.0, macOSApplicationExtension 14.0, *) {
            return  containerBackground(color, for: .widget)
        } else {
            return background(color)
        }
    }
}
