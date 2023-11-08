//
//  DataService.swift
//  WidgetExtensionExtension
//
//  Created by David Gunawan on 11/10/23.
//

import Foundation
import SwiftUI

struct DataService {
    @AppStorage("runtime", store: UserDefaults(suiteName: "group.adeva.Tuicitis")) private var duration = 0
    
    func reduce() {
        duration -= 1
    }
    
    func progress() -> Int {
        return duration
    }
}
