//
//  ContentView.swift
//  Tucitis
//
//  Created by Allicia Viona Sagi on 05/09/23.
//

import SwiftUI
import ActivityKit
import WidgetKit

struct ContentView: View {
    @State private var showAlert = false
    @State private var alertMsg = ""
    @ObservedObject var liveActivity: LiveActivityManager
    @AppStorage("sharedData", store: UserDefaults(suiteName: "group.adeva.Tuicitis")) var sharedDuration = 0
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                MachineStatusView(liveActivity: liveActivity, onStartWashing: startWashing, onStopWashing: stopWashing)
                Spacer()
            }
            .navigationTitle("Wash")
            .padding()
            .onOpenURL(perform: handleOpenURL)
            .alert(isPresented: $showAlert, content: washingAlert)
        }
    }

    /// Handles URL actions to start or stop the washing process.
    /// - Parameter url: The URL indicating the action to be taken.
    private func handleOpenURL(_ url: URL) {
        withAnimation {
            if url.absoluteString.contains("stop") {
                stopWashing()
            } else {
                startWashing()
            }
        }
    }
    
    /// Starts the washing process and updates the UI accordingly.
    private func startWashing() {
        alertMsg = "Washing Start"
        showAlert = true
        LiveActivityManager.shared.simulate()
    }

    /// Stops the washing process and updates the UI accordingly.
    private func stopWashing() {
        alertMsg = "Washing Stop"
        showAlert = true
        Task {
            await LiveActivityManager.shared.stopSimulate()
        }
    }

    /// Generates an alert based on the current state of the washing process.
    /// - Returns: An `Alert` object to be displayed.
    private func washingAlert() -> Alert {
        Alert(title: Text("Washing Event"), message: Text(alertMsg), dismissButton: .default(Text("OK")))
    }
}

/// `MachineStatusView`: A subview of `ContentView` displaying the current status of the washing machine.
///
/// This view shows the current state of the washing process, including the timer and action buttons to start or stop the wash. It uses callbacks to interact with the parent `ContentView`.

struct MachineStatusView: View {
    @ObservedObject var liveActivity: LiveActivityManager
    var onStartWashing: () -> Void
    var onStopWashing: () -> Void

    var body: some View {
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
                        if liveActivity.duration == 0 {
                            Text("Not Started")
                                .foregroundStyle(.white)
                                .fontWeight(.regular)
                        } else {
                            Text("Done in")
                                .foregroundStyle(.white)
                                .fontWeight(.regular)
                            Text("\(liveActivity.duration) seconds")
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
                    onStartWashing()
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
                    onStopWashing()
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
                Text("\(liveActivity.currentState) Step")
                    .foregroundStyle(.white)
                    .fontWeight(.regular)
                Spacer()
                if liveActivity.duration != 0 {
                    Text("\(liveActivity.duration) seconds")
                        .font(.callout)
                        .foregroundStyle(.white)
                        .fontWeight(.regular)
                } else {
                    Text("-")
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
}

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.1), radius: 10)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(liveActivity: LiveActivityManager.shared)
    }
}

