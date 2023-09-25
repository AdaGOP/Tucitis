//
//  ContentView.swift
//  Tucitis
//
//  Created by Allicia Viona Sagi on 05/09/23.
//

import SwiftUI

struct ContentView: View {
    var buttonCornerRadius = 30.0
    
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
                                Text("8 minutes")
                                    .foregroundStyle(.green)
                                    .fontWeight(.regular)
                            }
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    HStack(alignment: .center) {
                        Button {
                            
                        } label: {
                            Text("Stop")
                                .padding()
                                .foregroundColor(.white)
                                .frame(width: 130)
                        }
                        .buttonStyle(.bordered)
                        .tint(.green)
                        .buttonBorderShape(.capsule)
                        Spacer()
                        Button {
                            
                        } label: {
                            Text("Pause")
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
                        Text("1:26")
                            .foregroundStyle(.white)
                            .fontWeight(.regular)
                    }
                    .padding(.all, 8)
                    .background(.green.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.leading, 16)
                    .padding(.trailing, 16)
                    HStack {
                        Image(systemName: "timer")
                            .foregroundColor(.green)
                            .padding(.leading, 16)
                        Text("Cold Wash")
                            .font(.body)
                            .foregroundStyle(.white)
                        Spacer()
                        Image(systemName: "timer")
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
