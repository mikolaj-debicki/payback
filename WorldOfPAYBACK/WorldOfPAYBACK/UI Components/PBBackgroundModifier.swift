//
//  PBBackgroundModifier.swift
//  WorldOfPAYBACK
//
//  Created by Mikołaj Dębicki on 31/01/2024.
//

import SwiftUI

extension View {
    func applyPBBackground() -> some View {
        return self
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.linearGradient(colors: [.white, .blue],
                                            startPoint: .topLeading,
                                            endPoint: .bottom))
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 2)
            }
    }
}
