//
//  WidgetExtensionBundle.swift
//  WidgetExtension
//
//  Created by David Gunawan on 05/09/23.
//

import WidgetKit
import SwiftUI

@main
struct WidgetExtensionBundle: WidgetBundle {
    var body: some Widget {
        WidgetExtension()
        WidgetExtensionLiveActivity()
    }
}
