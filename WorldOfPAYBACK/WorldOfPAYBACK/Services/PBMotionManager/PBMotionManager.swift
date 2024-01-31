//
//  PBMotionManager.swift
//  WorldOfPAYBACK
//
//  Created by Mikołaj Dębicki on 30/01/2024.
//

import SwiftUI
import CoreMotion

class PBMotionManager: ObservableObject, PBMotionManaging {

    static let shared = PBMotionManager()
    @Published var manager: CMMotionManager = .init()
    @Published var roll: CGFloat = 0.0
    @Published var pitch: CGFloat = 0.0

    // rollValues and pitchValues arrays are present to smooth out the changes in roll an pitch and make the values more consistent
    var rollValues = [Double](repeating: 0.0, count: 40)
    var pitchValues = [Double](repeating: 0.0, count: 40)
    var currentIndex = 0

    func startMotionUpdates() {
        if !manager.isDeviceMotionActive {
            manager.deviceMotionUpdateInterval = 1/20
            manager.startDeviceMotionUpdates(to: .main) { [weak self] motion, _ in
                guard let self = self,
                      let attitude = motion?.attitude else { return }
                let rollAngle = attitude.roll
                let pitchAngle = attitude.pitch
                self.rollValues[self.currentIndex] = rollAngle
                self.pitchValues[self.currentIndex] = pitchAngle
                self.currentIndex = (self.currentIndex + 1) % 40
                self.roll = self.rollValues.reduce(0, +) / 40
                self.pitch = self.pitchValues.reduce(0, +) / 40
            }
        }
    }

    func stopMotionUpdates() {
        manager.stopDeviceMotionUpdates()
    }
}
