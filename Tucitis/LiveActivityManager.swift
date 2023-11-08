//
//  LiveActivitiyManager.swift
//  Tucitis
//
//  Created by David Gunawan on 06/11/23.
//

import Foundation
import ActivityKit

final class LiveActivitiyManager {
    private let cleaningAttributes: MachineAttributes
    private var cleaningActivity: Activity<MachineAttributes>?
    static let shared = LiveActivitiyManager()
    
    private init() {
        cleaningAttributes = MachineAttributes(orderNumber: 1)
        setupActivity()
    }
    
    func simulate() {
        setupActivity()
        Task {
            try await Task.sleep(se: 10_000_000_000)
            await updateActivity(to: .init(currentOrder: 1))
            try await Task.sleep(nanoseconds: 10_000_000_000)
            await updateActivity(to: .init(currentOrder: 1))
            try await Task.sleep(nanoseconds: 10_000_000_000)
            await updateActivity(to: .init(currentOrder: 1))
            print("About to take order")
            await updateActivity(to: .init(status: .aboutToTake, currentOrder: 1))
            try await Task.sleep(nanoseconds: 10_000_000_000)
            print("Making order")
            await updateActivity(to: .init(status: .making, currentOrder: 1))
            try await Task.sleep(nanoseconds: 10_000_000_000)
            print("Order ready")
            await updateActivity(to: .init(status: .ready, currentOrder: 1))
            try await Task.sleep(nanoseconds: 15_000_000_000)
            await cleaningActivity?.end(
                ActivityContent(state: MachineAttributes.ContentState.init(status: .ready, currentOrder: 1), staleDate: nil),
                dismissalPolicy: .default
            )
            cleaningActivity = nil
        }
    }
}
