//
//  MachineAttributes.swift
//  Tucitis
//
//  Created by David Gunawan on 06/11/23.
//

import ActivityKit

/// Represents attributes for a machine activity.
struct MachineAttributes: ActivityAttributes {
    
    /// The order number associated with the machine activity.
    let orderNumber: Int

    /// Represents the dynamic state of the machine during a live activity.
    struct ContentState: Codable, Hashable {
        
        /// Represents the various statuses of the machine.
        enum MachineStatus: Float, Codable, Hashable {
            case wash = 1
            case rinse = 2
            case spin = 3
            case stop = 4
            
            /// A textual description of the machine status.
            var description: String {
                switch self {
                case .wash: return "Wash"
                case .rinse: return "Rinse"
                case .spin: return "Spin"
                case .stop: return "Stop"
                }
            }
        }
        
        /// The current status of the machine.
        let status: MachineStatus

        /// The current order being processed by the machine.
        var currentOrder: Int

        /// Initializes a new state with the specified status and order.
        /// - Parameters:
        ///   - status: The initial status of the machine. Defaults to `.wash`.
        ///   - currentOrder: The initial order being processed. Defaults to `1`.
        init(status: MachineStatus = .wash, currentOrder: Int = 1) {
            self.status = status
            self.currentOrder = currentOrder
        }
    }
}
