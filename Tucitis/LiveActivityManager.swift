//
//  LiveActivityManager.swift
//  Tucitis
//
//  Created by David Gunawan on 06/11/23.
//

import Foundation
import ActivityKit

final class LiveActivityManager: ObservableObject {
    private let cleaningAttributes: MachineAttributes
    private var cleaningActivity: Activity<MachineAttributes>?
    static let shared = LiveActivityManager()
    private let staticOrderNumber = 1
    @Published var duration = 0
    @Published var currentState = "Idle"
    
    private init() {
        cleaningAttributes = MachineAttributes(orderNumber: staticOrderNumber)
    }
    
    func simulate() {
        setupActivity()
        Task {
            try await Task.sleep(nanoseconds: 2_000_000_000)
            await updateActivity(to: .init(currentOrder: 1))
            try await Task.sleep(nanoseconds: 3_000_000_000)
            await updateActivity(to: .init(currentOrder: 2))
            try await Task.sleep(nanoseconds: 3_000_000_000)
            await updateActivity(to: .init(currentOrder: 3))
            print("Rinse")
            await updateActivity(to: .init(status: .rinse, currentOrder: staticOrderNumber))
            try await Task.sleep(nanoseconds: 4_000_000_000)
            print("Spin")
            await updateActivity(to: .init(status: .spin, currentOrder: staticOrderNumber))
            try await Task.sleep(nanoseconds: 4_000_000_000)
            print("Stop")
            await updateActivity(to: .init(status: .stop, currentOrder: staticOrderNumber))
//            try await Task.sleep(nanoseconds: 4_000_000_000)
            print("Washing Stop")
            await stopSimulate()
        }
    }
    
    func stopSimulate() async {
        await cleaningActivity?.end(
            ActivityContent(state: MachineAttributes.ContentState.init(status: .stop, currentOrder: staticOrderNumber), staleDate: nil),
            dismissalPolicy: .default
        )
        currentState = "Idle"
        cleaningActivity = nil
    }
}

// MARK: - Helpers
private extension LiveActivityManager {
    func setupActivity() {
        if cleaningActivity != nil {
            return
        }
        
        let initialState = MachineAttributes.ContentState(status: .wash)
        let content = ActivityContent(state: initialState, staleDate: nil, relevanceScore: 1.0)
        
        do {
            currentState = initialState.status.description
            startTimerCountdown(countdownDuration: 16) {
                print("Countdown completed")
            }
            cleaningActivity = try Activity.request(
                attributes: cleaningAttributes,
                content: content,
                pushType: nil
            )
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateActivity(to state: MachineAttributes.ContentState) async {
        var alert: AlertConfiguration?
        if state.status == .stop {
            alert = AlertConfiguration(
                title: "\(state.status.description)",
                body: "",
                sound: .default
            )
        }
        await cleaningActivity?.update(
            ActivityContent<MachineAttributes.ContentState>(
                state: state,
                staleDate: nil
            ),
            alertConfiguration: alert
        )
    }
    
    func startTimerCountdown(countdownDuration: TimeInterval, completion: @escaping () -> Void) {
        let startTime = Date()
        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] timer in
            let timeElapsed = Date().timeIntervalSince(startTime)
            duration = Int(countdownDuration) - Int(timeElapsed)
            if timeElapsed >= countdownDuration {
                duration = 0
                timer.invalidate()
                completion()
            }
        }
        RunLoop.current.add(timer, forMode: .common)
    }
}
