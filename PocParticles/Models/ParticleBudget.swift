//
//  ParticleBudget.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 14/08/25.
//


import Foundation


struct ParticleBudget: Sendable {
    var policy: Policy
    var perCategoryCaps: [ParticleCategory: Int]
    
    init(
        policy: Policy = .unlimited,
        perCategoryCaps: [ParticleCategory: Int] = [:]
    ) {
        
        self.policy = policy
        self.perCategoryCaps = perCategoryCaps
    }
}

