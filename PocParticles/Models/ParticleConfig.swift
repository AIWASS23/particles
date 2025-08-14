//
//  ParticleConfig.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 14/08/25.
//


import CoreGraphics
import Foundation
import SwiftUI

struct ParticleConfig: Sendable, Hashable {
    var name: String
    var runtime: any ParticleRuntime
    var spawnRate: Double = 50 // particles per second
    var lifetime: ClosedRange<Double> = 1.0...2.0
    var opacity: Double = 1.0
    var speed: ClosedRange<Double> = 30...60
    var angle: ClosedRange<Double> = (Double.pi * 0.5)...(Double.pi * 0.5)
    var depth: Double = 0
    var priority: Int = 0
    var categories: Set<ParticleCategory> = [.ui]
    var trigger: TriggerPredicate? = nil
    
    
    static func == (lhs: ParticleConfig, rhs: ParticleConfig) -> Bool {
        lhs.name == rhs.name &&
        lhs.spawnRate == rhs.spawnRate &&
        lhs.lifetime == rhs.lifetime &&
        lhs.opacity == rhs.opacity &&
        lhs.speed == rhs.speed &&
        lhs.angle == rhs.angle &&
        lhs.depth == rhs.depth &&
        lhs.priority == rhs.priority &&
        lhs.categories == rhs.categories
        // Ignora runtime e trigger?
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(spawnRate)
        hasher.combine(lifetime.lowerBound)
        hasher.combine(lifetime.upperBound)
        hasher.combine(opacity)
        hasher.combine(speed.lowerBound)
        hasher.combine(speed.upperBound)
        hasher.combine(angle.lowerBound)
        hasher.combine(angle.upperBound)
        hasher.combine(depth)
        hasher.combine(priority)
        hasher.combine(categories)
        // Ignora runtime e trigger?
    }
    
}
