//
//  LiveActivityManager.swift
//  Tucitis
//
//  Created by David Gunawan on 06/11/23.
//

import Foundation
import ActivityKit

/// `LiveActivityManager` handles the simulation of a cleaning activity and manages its state.
///
/// This singleton class is responsible for starting, updating, and stopping the cleaning activity.
/// It also tracks the current state and duration of the cleaning activity.
final class LiveActivityManager: ObservableObject {

    // Singleton instance for global access
    static let shared = LiveActivityManager()

    // MARK: - Private Properties
    private let cleaningAttributes: MachineAttributes
    private var cleaningActivity: Activity<MachineAttributes>?
    private let staticOrderNumber = 1
    private var timer: Timer?

    // MARK: - Published Properties
    @Published var duration = 0
    @Published var currentState = "Idle"

    // MARK: - Initializer
    private init() {
        cleaningAttributes = MachineAttributes(orderNumber: staticOrderNumber)
    }

    // MARK: - Public Methods

    /// Starts the cleaning activity simulation.
    func simulate() {
        guard setupActivity() else { return }
        performCleaningSteps()
    }
    
    /// Stops the cleaning activity simulation.
    func stopSimulate() async {
        await endActivity()
    }
}

// MARK: - Private Helpers
private extension LiveActivityManager {

    /// Sets up the cleaning activity if not already active.
    /// - Returns: A Boolean indicating whether the setup was successful.
    func setupActivity() -> Bool {
        if cleaningActivity != nil { return false }

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
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }

    /// Performs the sequential steps of the cleaning process.
    func performCleaningSteps() {
        Task {
            try await Task.sleep(nanoseconds: 2_000_000_000)
            await updateActivity(to: .init(currentOrder: 1))
            try await Task.sleep(nanoseconds: 3_000_000_000)
            await updateActivity(to: .init(currentOrder: 2))
            try await Task.sleep(nanoseconds: 3_000_000_000)
            await updateActivity(to: .init(currentOrder: 3))
            print("Rinse")
            await updateActivity(to: .init(status: .rinse, currentOrder: 2))
            try await Task.sleep(nanoseconds: 4_000_000_000)
            print("Spin")
            await updateActivity(to: .init(status: .spin, currentOrder: 3))
            try await Task.sleep(nanoseconds: 4_000_000_000)
            print("Stop")
            await updateActivity(to: .init(status: .stop, currentOrder: 4))
            print("Washing Stop")
            await stopSimulate()
        }
    }

    /// Updates the state of the cleaning activity.
    /// - Parameter state: The new state to update the activity to.
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

    /// Starts a countdown timer and updates the duration.
    /// - Parameters:
    ///   - countdownDuration: The total duration of the countdown.
    ///   - completion: A closure that gets called upon completion of the countdown.
    func startTimerCountdown(countdownDuration: TimeInterval, completion: @escaping () -> Void) {
        let startTime = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] timer in
            let timeElapsed = Date().timeIntervalSince(startTime)
            duration = Int(countdownDuration) - Int(timeElapsed)
            if timeElapsed >= countdownDuration {
                duration = 0
                timer.invalidate()
                completion()
            }
        }
        RunLoop.current.add(timer!, forMode: .common)
    }

    /// Ends the current cleaning activity.
    func endActivity() async {
        await cleaningActivity?.end(
            ActivityContent(state: MachineAttributes.ContentState.init(status: .stop, currentOrder: 4), staleDate: nil),
            dismissalPolicy: .default
        )
        currentState = "Idle"
        cleaningActivity = nil
    }
}


//final class LiveActivityManager: ObservableObject {
//    private let cleaningAttributes: MachineAttributes
//    private var cleaningActivity: Activity<MachineAttributes>?
//    static let shared = LiveActivityManager()
//    private let staticOrderNumber = 1
//    @Published var duration = 0
//    @Published var currentState = "Idle"
//    
//    private init() {
//        cleaningAttributes = MachineAttributes(orderNumber: staticOrderNumber)
//    }
//    
//    func simulate() {
//        setupActivity()
//        Task {
//            try await Task.sleep(nanoseconds: 2_000_000_000)
//            await updateActivity(to: .init(currentOrder: 1))
//            try await Task.sleep(nanoseconds: 3_000_000_000)
//            await updateActivity(to: .init(currentOrder: 2))
//            try await Task.sleep(nanoseconds: 3_000_000_000)
//            await updateActivity(to: .init(currentOrder: 3))
//            print("Rinse")
//            await updateActivity(to: .init(status: .rinse, currentOrder: 2))
//            try await Task.sleep(nanoseconds: 4_000_000_000)
//            print("Spin")
//            await updateActivity(to: .init(status: .spin, currentOrder: 3))
//            try await Task.sleep(nanoseconds: 4_000_000_000)
//            print("Stop")
//            await updateActivity(to: .init(status: .stop, currentOrder: 4))
////            try await Task.sleep(nanoseconds: 4_000_000_000)
//            print("Washing Stop")
//            await stopSimulate()
//        }
//    }
//    
//    func stopSimulate() async {
//        await cleaningActivity?.end(
//            ActivityContent(state: MachineAttributes.ContentState.init(status: .stop, currentOrder: 4), staleDate: nil),
//            dismissalPolicy: .default
//        )
//        currentState = "Idle"
//        cleaningActivity = nil
//    }
//}
//
//// MARK: - Helpers
//private extension LiveActivityManager {
//    func setupActivity() {
//        if cleaningActivity != nil {
//            return
//        }
//        
//        let initialState = MachineAttributes.ContentState(status: .wash)
//        let content = ActivityContent(state: initialState, staleDate: nil, relevanceScore: 1.0)
//        
//        do {
//            currentState = initialState.status.description
//            startTimerCountdown(countdownDuration: 16) {
//                print("Countdown completed")
//            }
//            cleaningActivity = try Activity.request(
//                attributes: cleaningAttributes,
//                content: content,
//                pushType: nil
//            )
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
//    
//    func updateActivity(to state: MachineAttributes.ContentState) async {
//        var alert: AlertConfiguration?
//        if state.status == .stop {
//            alert = AlertConfiguration(
//                title: "\(state.status.description)",
//                body: "",
//                sound: .default
//            )
//        }
//        await cleaningActivity?.update(
//            ActivityContent<MachineAttributes.ContentState>(
//                state: state,
//                staleDate: nil
//            ),
//            alertConfiguration: alert
//        )
//    }
//    
//    func startTimerCountdown(countdownDuration: TimeInterval, completion: @escaping () -> Void) {
//        let startTime = Date()
//        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] timer in
//            let timeElapsed = Date().timeIntervalSince(startTime)
//            duration = Int(countdownDuration) - Int(timeElapsed)
//            if timeElapsed >= countdownDuration {
//                duration = 0
//                timer.invalidate()
//                completion()
//            }
//        }
//        RunLoop.current.add(timer, forMode: .common)
//    }
//}
