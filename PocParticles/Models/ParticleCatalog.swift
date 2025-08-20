//
//  ParticleCatalog.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 14/08/25.
//


import Foundation

struct ParticleCatalog: Sendable, Hashable {
    var presets: [String: ParticleConfig]
    
    init(
        presets: [String: ParticleConfig] = [:]
    ) {
        self.presets = presets
    }
    
    subscript(_ name: String) -> ParticleConfig? {
        presets[name]
    }
    
    static var `default`: ParticleCatalog {
        let rain = ParticleBuilder(
            name: "Rain",
            runtime: RainParticle()
        )
            .style(.rain)
            .spawnRate(120)
            .lifetime(2.0...3.0)
            .opacity(0.6)
            .config
        
        let dust = ParticleBuilder(
            name: "Dust",
            runtime: DustParticle()
        )
            .style(.dust)
            .spawnRate(30)
            .opacity(0.5)
            .config
        
        let sparkle = ParticleBuilder(
            name: "Sparkle",
            runtime: SparkleParticle()
        )
            .style(.sparkle)
            .spawnRate(80)
            .lifetime(0.5...1.2)
            .config
        
        return ParticleCatalog(presets: [rain.name: rain, dust.name: dust, sparkle.name: sparkle])
    }
    
    static func + (lhs: ParticleCatalog, rhs: ParticleCatalog) -> ParticleCatalog {
        ParticleCatalog(presets: lhs.presets.merging(rhs.presets) { _, r in r })
    }
}
