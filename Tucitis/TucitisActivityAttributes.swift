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
        var robotName: String
        var cleaningTime: ClosedRange<Date>
    }
    
    var coverageArea: Int
}
