//
//  ParticleConfigSetKey.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 14/08/25.
//


import SwiftUI

extension EnvironmentValues {
    var particleConfigSet: [ParticleConfig] {
        get { self[ParticleConfigSetKey.self] }
        set { self[ParticleConfigSetKey.self] = newValue } }
}

