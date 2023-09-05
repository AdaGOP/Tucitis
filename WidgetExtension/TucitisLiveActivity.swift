//
//  TucitisLiveActivity.swift
//  TucitisLiveActivity
//
//  Created by David Gunawan on 05/09/23.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct TucitisLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TucitisActivityAttributes.self) { context in
            // MARK: - For devices that don't support the Dynamic Island.
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Your \(context.state.robotName) is on the way!")
                            .font(.headline)
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(.secondary)
                            HStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(.blue)
                                    .frame(width: 50)
                                Image(systemName: "shippingbox.circle.fill")
                                    .foregroundColor(.white)
                                    .padding(.leading, -25)
                                Image(systemName: "arrow.forward")
                                    .foregroundColor(.white.opacity(0.5))
                                Image(systemName: "ellipsis")
                                    .foregroundColor(.white.opacity(0.5))
                                Text(timerInterval: context.state.cleaningTime, countsDown: true)
                                    .bold()
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.8))
                                    .multilineTextAlignment(.center)
                                Image(systemName: "ellipsis")
                                    .foregroundColor(.white.opacity(0.5))
                                Image(systemName: "arrow.forward")
                                    .foregroundColor(.white.opacity(0.5))
                                Image(systemName: "house.circle.fill")
                                    .foregroundColor(.green)
                                    .background(.white)
                                    .clipShape(Circle())
                            }
                        }
                    }
                    Spacer()
                    VStack {
                        Text("2 🍕")
                            .font(.title)
                            .bold()
                        Spacer()
                    }
                }.padding(5)
                Text("You've already paid: $9.9 Delivery Fee 💸")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 5)
            }.padding(15)
            // MARK: - For Dynamic Island
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Label("2 Pizza", systemImage: "bag")
                        .font(.title3)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Label {
                        Text(timerInterval: context.state.cleaningTime, countsDown: true)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 50)
                            .monospacedDigit()
                            .font(.caption2)
                    } icon: {
                        Image(systemName: "timer")
                    }
                    .font(.title2)
                }
                DynamicIslandExpandedRegion(.center) {
                    Text("\(context.state.robotName) is on the way!")
                        .lineLimit(1)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    // Deep Linking
                    HStack {
                        Link(destination: URL(string: "pizza://contact+TIM")!) {
                             Label("Contact driver", systemImage: "phone.circle.fill")
                                .font(.caption)
                                .padding()
                         }.background(Color.accentColor)
                         .clipShape(RoundedRectangle(cornerRadius: 15))
                        Spacer()
                        Link(destination: URL(string: "pizza://cancelOrder")!) {
                             Label("Cancel Order", systemImage: "xmark.circle.fill")
                                .font(.caption)
                                .padding()
                         }.background(Color.red)
                         .clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                }
            } compactLeading: {
                Label {
                    Text("2 Pizza")
                } icon: {
                    Image(systemName: "bag")
                }
                .font(.caption2)
            } compactTrailing: {
                Text(timerInterval: context.state.cleaningTime, countsDown: true)
                    .multilineTextAlignment(.center)
                    .frame(width: 40)
                    .font(.caption2)
            } minimal: {
                VStack(alignment: .center) {
                    Image(systemName: "timer")
                    Text(timerInterval: context.state.cleaningTime, countsDown: true)
                        .multilineTextAlignment(.center)
                        .monospacedDigit()
                        .font(.caption2)
                }
            }
            .keylineTint(.accentColor)
        }
    }
}

struct TucitisLiveActivity_Previews: PreviewProvider {
    static let attributes = TucitisActivityAttributes(coverageArea: 10)
    static let contentState = TucitisActivityAttributes.ContentState(robotName: "Tucitis", cleaningTime: Date()...Date().addingTimeInterval(15 * 60))

    static var previews: some View {
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.compact))
            .previewDisplayName("Island Compact")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.expanded))
            .previewDisplayName("Island Expanded")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.minimal))
            .previewDisplayName("Minimal")
        attributes
            .previewContext(contentState, viewKind: .content)
            .previewDisplayName("Notification")
    }
}
