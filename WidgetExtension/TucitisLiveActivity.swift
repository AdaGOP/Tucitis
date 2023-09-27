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
                    VStack (alignment: .leading) {
                        Text("Step \(context.state.stepCounter) of 4: \(context.state.stepName)")
                            .font(.title3)
                            .bold()
                            .foregroundStyle(.green)
                        HStack {
                            Text("Done in")
                                .font(.body)
                                .foregroundStyle(.white)
                            Text(context.state.cleaningTime, style: .timer)
                                .frame(maxWidth: 32)
                                .font(.callout)
                                .foregroundColor(.green)
                            Text("minutes")
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
                    Image(systemName: "washer.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundStyle(.green)
                        .padding(.leading, 12)
                        .padding(.top, 4)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    HStack {
                        VStack (alignment: .leading) {
                            Text("Step: \(context.state.stepName)")
                                .font(.title3)
                                .bold()
                                .foregroundStyle(.green)
                            HStack {
                                Text("Done in ")
                                    .frame(maxWidth: .infinity)
                                    .font(.body)
                                    .foregroundStyle(.white)
                                Text(context.state.cleaningTime, style: .timer)
                                    .frame(maxWidth: 35)
                                    .font(.callout)
                                    .foregroundColor(.green)
                            }
                        }
                    }
                }
                DynamicIslandExpandedRegion(.bottom) {
                    // Deep Linking
                    HStack {
                        Link(destination: URL(string: "tucitis://stop")!) {
                            Label("Stop", systemImage: "stop.fill")
                                .frame(maxWidth: .infinity)
                                .font(.body)
                                .padding()
                        }.background(.green)
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                        Link(destination: URL(string: "tucitis://pause")!) {
                            Label("Pause", systemImage: "pause.fill")
                                .frame(maxWidth: .infinity)
                                .font(.body)
                                .padding()
                        }.background(.green)
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                    }
                }
            } compactLeading: {
                Label {
                    Text(context.state.stepName)
                        .foregroundColor(.green)
                } icon: {
                    
                }
                .font(.caption2)
            } compactTrailing: {
                Text(context.state.cleaningTime, style: .timer)
                    .multilineTextAlignment(.center)
                    .frame(width: 40)
                    .font(.caption2)
                    .foregroundColor(.green)
            } minimal: {
                VStack(alignment: .center) {
                    Text(context.state.cleaningTime, style: .timer)
                        .multilineTextAlignment(.center)
                        .monospacedDigit()
                        .font(.caption2)
                        .foregroundColor(.green)
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
