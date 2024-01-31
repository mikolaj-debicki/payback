//
//  TransactionDetailView.swift
//  WorldOfPAYBACK
//
//  Created by Mikołaj Dębicki on 29/01/2024.
//

import SwiftUI

struct TransactionDetailView: View {
    private let partnerName: String
    private let description: String?
    // Motion Manager is used for a cool 3D rotation animation applied to the information card in order to make this rather empty view less boring (use a physical device to play around with it)
    @StateObject private var motionManager: PBMotionManager = PBMotionManager.shared

    init(for data: TransactionViewData) {
        partnerName = data.partnerDisplayName
        description = data.description
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0){
                card
                Spacer()
            }
            .navigationTitle("detailsTitle")
        }
        .onAppear {
            motionManager.startMotionUpdates()
        }
        .onDisappear {
            motionManager.stopMotionUpdates()
        }
    }
}

extension TransactionDetailView {
    var card: some View {
        VStack(spacing: 10) {
            Text(partnerName)
                .font(.system(size: 25, weight: .semibold))
                .foregroundStyle(.blue)
            if let description = description {
                Text(description)
                    .font(.system(size: 20, weight: .regular))
                    .foregroundStyle(.black60)
            }
        }
        .padding(20)
        .applyPBBackground()
        .padding(20)
        .rotation3DEffect(Angle(radians: motionManager.roll * 0.2),
                          axis: (x: 0.0, y: 1.0, z: 0.0))
        .scaleEffect(1-(min(abs(motionManager.roll * 0.2), 0.15)))
        .animation(.easeInOut, value: motionManager.roll)
    }
}
