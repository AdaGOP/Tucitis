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
    
    public struct ContentState: Codable, Hashable {
        var stepCounter: Int
        var stepName: String
        var robotName: String
        var cleaningTime: Date
    }
    
    var coverageArea: Int
}
