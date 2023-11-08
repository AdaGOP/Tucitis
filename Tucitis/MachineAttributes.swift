//
//  MachineAttributes.swift
//  Tucitis
//
//  Created by David Gunawan on 06/11/23.
//

import ActivityKit

struct MachineAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        
        enum MachineStatus: Float, Codable, Hashable {
            // MARK: Live Activities Will Update Its View When Content State is Updated
            case wash = 1
            case rinse = 2
            case spin = 3
            case stop = 4
            
            var description: String {
                switch self {
                case .wash:
                    return "Wash"
                case .rinse:
                    return "Rinse"
                case .spin:
                    return "Spin"
                case .stop:
                    return "Stop"
                }
            }
        }
        
        let status: MachineStatus
        var currentOrder: Int
        
        init(status: MachineStatus = .wash, currentOrder: Int = 1) {
            self.status = status
            self.currentOrder = currentOrder
        }
    }
    
    let orderNumber: Int
}
