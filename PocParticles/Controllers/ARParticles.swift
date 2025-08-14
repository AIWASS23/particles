//
//  ARParticles.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 14/08/25.
//


struct ARParticles {
    static var current = ARParticles()
    
    var controller = ParticlesController()
    
    var detectors: DetectionRegistry {
        get async {
            await DetectionRegistry.shared
        }
    }
}
