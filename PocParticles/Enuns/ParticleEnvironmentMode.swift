//
//  ParticleEnvironmentMode.swift
//  PocParticles
//
//  Created by Marcelo de Araújo on 26/08/25.
//


enum ParticleEnvironmentMode: String, CaseIterable, Identifiable {
    case twoD = "2D"
    case windowed = "Automatic"
    case mixed = "Mixed"
    case full = "Full Immersive"
    
    var id: String { rawValue }
}
