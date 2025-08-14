//
//  AccessibilityPolicy.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 14/08/25.
//


import Foundation

struct AccessibilityPolicy: Sendable {
    var autoContrastMinRatio: Double? = nil
    var reduceMotionScale: Double = 1.0
    
    init(
        autoContrast min: Double? = nil,
        reduceMotionScale: Double = 1.0
    ) {
        self.autoContrastMinRatio = min
        self.reduceMotionScale = max(0.1, reduceMotionScale)
    }
}
