//
//  DefaultButton.swift
//  Tucitis
//
//  Created by Allicia Viona Sagi on 06/10/23.
//

import SwiftUI

struct DefaultButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(TucitisColor.defaultGreen)
            .foregroundStyle(.white)
            .clipShape(Capsule())
    }
}
