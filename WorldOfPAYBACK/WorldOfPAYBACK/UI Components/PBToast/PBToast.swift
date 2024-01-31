//
//  PBToast.swift
//  WorldOfPAYBACK
//
//  Created by Mikołaj Dębicki on 31/01/2024.
//

import SwiftUI

struct PBToast: View {
    var message: String
    
    var body: some View {
        HStack {
            Text(LocalizedStringKey(message))
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(.black60)
                .lineLimit(2)
        }
        .padding(10)
        .applyPBBackground()
    }
}
