//
//  MachineStatus.swift
//  Tucitis
//
//  Created by David Gunawan on 04/10/23.
//

import Foundation
 
class MachineStatus {
    var stepName: String
    var stepStatus: Step
    var stepCounter: Int
    var cleaningTime: Date
 
    init(stepName: String = "", stepStatus: Step = .wash, stepCounter: Int = 0, cleaningTime: Date = Date.now) {
        self.stepName = stepName
        self.stepStatus = stepStatus
        self.stepCounter = stepCounter
        self.cleaningTime = cleaningTime
    }
    
}
