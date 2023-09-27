//
//  ContentView.swift
//  Tucitis
//
//  Created by Allicia Viona Sagi on 05/09/23.
//

import SwiftUI
import ActivityKit

struct ContentView: View {
    var buttonCornerRadius = 30.0
    @State var showAlert: Bool = false
    @State var alertMsg: String = ""
    @State var activities = Activity<TucitisActivityAttributes>.activities
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Current Cycle")
                VStack {
                    HStack {
                        Image(systemName: "timer")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60)
                            .padding(.all, 20)
                            .foregroundColor(.green)
                        VStack(alignment: .leading) {
                            Text("Quick Wash")
                                .foregroundStyle(.green)
                                .font(.title2)
                                .bold()
                            HStack {
                                Text("Done in")
                                    .foregroundStyle(.white)
                                .fontWeight(.regular)
                                if activities.isEmpty {
                                    Text("_ minutes")
                                        .foregroundStyle(.green)
                                        .fontWeight(.regular)
                                } else {
                                    Text(activities[0].contentState.cleaningTime, style: .timer)
                                        .font(.callout)
                                        .foregroundStyle(.green)
                                        .fontWeight(.regular)
                                }
                            }
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    HStack(alignment: .center) {
                        Button {
                            startLiveActivities()
                        } label: {
                            Text("Start")
                                .padding()
                                .foregroundColor(.white)
                                .frame(width: 130)
                        }
                        .buttonStyle(.bordered)
                        .tint(.green)
                        .buttonBorderShape(.capsule)
                        Spacer()
                        Button {
                            stopLiveActivities()
                        } label: {
                            Text("Stop")
                                .padding()
                                .foregroundColor(.white)
                                .frame(width: 130)
                        }
                        .buttonStyle(.bordered)
                        .tint(.green)
                        .buttonBorderShape(.capsule)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    HStack {
                        Text("Rinse Step")
                            .foregroundStyle(.white)
                            .fontWeight(.regular)
                        Spacer()
                        if activities.isEmpty {
                            Text("_ minutes")
                                .foregroundStyle(.white)
                                .fontWeight(.regular)
                        } else {
                            Text(.now + 120, style: .timer)
                                .font(.callout)
                                .foregroundStyle(.white)
                                .fontWeight(.regular)
                        }
                    }
                    .padding(.all, 8)
                    .background(.green.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.leading, 16)
                    .padding(.trailing, 16)
                    HStack {
                        Image(systemName: "drop.fill")
                            .foregroundColor(.green)
                            .padding(.leading, 16)
                        Text("Cold Wash")
                            .font(.body)
                            .foregroundStyle(.white)
                        Spacer()
                        Image(systemName: "repeat.circle")
                            .foregroundColor(.green)
                        Text("Low Spin")
                            .font(.body)
                            .foregroundStyle(.white)
                            .padding(.trailing, 16)
                    }.padding()
                }
                .frame(maxWidth: .infinity)
                .background(Color(red: 32/255, green: 36/255, blue: 38/255))
                .modifier(CardModifier())
                .padding(.top, 12)
                Spacer()
            }
            .navigationTitle("Wash")
            .padding()
            .onOpenURL(perform: { url in
                withAnimation {
                    if url.absoluteString.contains("stop") {
                        stopLiveActivities()
                    } else {
                        startLiveActivities()
                    }
                }
            })
            .alert(isPresented: $showAlert, content: {
                Alert(title: Text("Washing Event"), message: Text(alertMsg), dismissButton: .default(Text("OK")))
            })
        }
    }
    
    // MARK: - Functions
    func startLiveActivities() {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
              print("Activities are not enabled!")
              return
            }
        
        let tucitisAttributes = TucitisActivityAttributes(coverageArea: 2)
        let initialContentState = TucitisActivityAttributes.ContentState(stepCounter: 1, stepName: Step.wash, robotName: "Tucitis", cleaningTime: .now + 480)
        do {
            let activity = try Activity<TucitisActivityAttributes>.request(attributes: tucitisAttributes, contentState: initialContentState, pushType: nil)
            alertMsg = "Washing Start"
            showAlert = true
        } catch {
            print(error.localizedDescription)
        }
    }

    func stopLiveActivities() {
        Task {
            for activity in Activity<TucitisActivityAttributes>.activities{
                await activity.end(dismissalPolicy: .immediate)
            }
            alertMsg = "Washing Stop"
            showAlert = true
            print("Cancelled Live Activity")
        }
    }
}



struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
