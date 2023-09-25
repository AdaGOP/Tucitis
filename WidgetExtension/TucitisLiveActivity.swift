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
            VStack {
                HStack {
                    Image(systemName: "washer.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.green)
                    Spacer()
                    VStack (alignment: .trailing) {
                        Text("Step \(context.state.stepCounter) of 4: \(context.state.stepName)")
                            .font(.title3)
                            .bold()
                            .foregroundStyle(.green)
                        HStack {
                            Text("Done in")
                                .font(.body)
                                .bold()
                                .foregroundStyle(.white)
                            Text(context.state.cleaningTime, style: .timer)
                                .bold()
                                .font(.callout)
                                .foregroundColor(.green)
                        }.frame(alignment: .trailing)
                            
                    }
                }.padding(5)
            }
            .padding(15)
            .background(.black)
            // MARK: - For Dynamic Island
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Label("Rinse", systemImage: "bag")
                        .font(.title3)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Label {
                        Text(context.state.cleaningTime, style: .timer)
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
                    Text(context.state.stepName)
                } icon: {
                    Image(systemName: "washer.fill")
                }
                .font(.caption2)
            } compactTrailing: {
                Text(context.state.cleaningTime, style: .timer)
                    .multilineTextAlignment(.center)
                    .frame(width: 40)
                    .font(.caption2)
            } minimal: {
                VStack(alignment: .center) {
                    Image(systemName: "timer")
                    Text(context.state.cleaningTime, style: .timer)
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
    static let contentState = TucitisActivityAttributes.ContentState(stepCounter: 3, stepName: "Rinse", robotName: "Tucitis", cleaningTime: .now + 120)
    
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
