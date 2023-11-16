//
//  Provider.swift
//  WidgetExtensionExtension
//
//  Created by David Gunawan on 16/11/23.
//

import WidgetKit
import SwiftUI

struct Provider: IntentTimelineProvider {
    typealias Entry = SimpleEntry
    
    let userDefaults = UserDefaults(suiteName: "group.adeva.Tuicitis")
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), duration: 1, step: "")
    }

    /// Purpose:
    ///     The getSnapshot function is used to create a single, quick view of the widget's current or preview state. This view is not meant for continuous display but for quick, temporary glimpses.
    /// When It's Called:
    ///     1. Preview in Widget Gallery: When users are browsing widgets in the gallery to add to their home screen, getSnapshot is called to provide a quick preview.
    ///     2. Widget Configuration: If the widget supports configuration, getSnapshot is called to show a preview during the configuration process.
    ///     3. Quick Look: Sometimes, the system may need to display a quick view of the widget's current state; getSnapshot is used here as well.
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), duration: readSharedData(), step: "Wash")
        completion(entry)
    }
    
    
///Purpose:
    ///The getTimeline function is used for providing a sequence of entries that the widget will cycle through over time. Each entry in the timeline has a date associated with it, telling the widget when to display that particular entry.
///When It's Called:
    ///1. Initial Widget Loading: When the widget is first loaded onto the home screen, getTimeline is called to establish the initial sequence of entries.
    ///2. Scheduled Updates: As the widget needs to update its content over time, getTimeline is called to refresh the entries according to the specified schedule in the timeline.
    ///3. After Widget Configuration: If the widget is configurable and the user changes the settings, getTimeline is called to reflect the new configuration in the displayed content.

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
