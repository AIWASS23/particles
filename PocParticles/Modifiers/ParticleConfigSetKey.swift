//
//  ParticleConfigSetKey.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 14/08/25.
//


import SwiftUI

// Store particle configs in the environment so Particle2DView can read them
struct ParticleConfigSetKey: EnvironmentKey {
    static let defaultValue: [ParticleConfig] = []
}

