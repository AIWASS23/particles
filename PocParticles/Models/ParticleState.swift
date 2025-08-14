//
//  ParticleState.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 14/08/25.
//

import Foundation


struct ParticleState: Sendable, Hashable, Identifiable {
    let id = UUID()
    var position: CGPoint
    var velocity: CGVector
    var life: Double
    var maxLife: Double
    var opacity: Double
}
