//
//  TucitisActivityAttributes.swift.swift
//  Tucitis
//
//  Created by David Gunawan on 05/09/23.
//

import SwiftUI
import ActivityKit

struct TucitisActivityAttributes: ActivityAttributes {
    public typealias LiveCleaningStatus = ContentState
    
    struct ContentState: Codable, Hashable {
        // MARK: Live Activities Will Update Its View When Content State is Updated
        var stepCounter: Int
        var stepName: Step
        var robotName: String
        var cleaningTime: Date
    }
    
    var coverageArea: Int
}

// MARK: Machine Status

enum Step : String, CaseIterable, Codable, Equatable {
    case wash = "Wash"
    case rinse = "Rinse"
    case spin = "Spin"
    case stop = "Stop"
    
    var caption: String {
        switch(self){
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
