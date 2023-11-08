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
    var buttonCornerRadius = 30.0
    @State var showAlert: Bool = false
    @State var alertMsg: String = ""
    @ObservedObject var liveActivity: LiveActivityManager
    @AppStorage("sharedData", store: UserDefaults(suiteName: "group.adeva.Tuicitis")) var sharedDuration: Int = 0
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
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
                            alertMsg = "Washing Start"
                            showAlert = true
                            sharedDuration = 16
                            WidgetCenter.shared.reloadAllTimelines()
                            LiveActivityManager.shared.simulate()
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
                            alertMsg = "Washing Stop"
                            showAlert = true
                            sharedDuration = 0
                            WidgetCenter.shared.reloadAllTimelines()
                            Task {
                                await LiveActivityManager.shared.stopSimulate()
                            }
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
            .navigationTitle("Wash")
            .padding()
            .onOpenURL(perform: { url in
                withAnimation {
                    if url.absoluteString.contains("stop") {
                        alertMsg = "Washing Stop"
                        showAlert = true
                        Task {
                            await LiveActivityManager.shared.stopSimulate()
                        }
                    } else {
                        alertMsg = "Washing Start"
                        showAlert = true
                        LiveActivityManager.shared.simulate()
                    }
                }
            })
            .alert(isPresented: $showAlert, content: {
                Alert(title: Text("Washing Event"), message: Text(alertMsg), dismissButton: .default(Text("OK")))
            })
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
        ContentView(liveActivity: LiveActivityManager.shared)
    }
}
