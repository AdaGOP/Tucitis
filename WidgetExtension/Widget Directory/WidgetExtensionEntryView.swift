//
//  WidgetExtensionEntryView.swift
//  WidgetExtensionExtension
//
//  Created by David Gunawan on 16/11/23.
//

import SwiftUI

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
