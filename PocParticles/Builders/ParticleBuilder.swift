//
//  ParticleBuilder.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 14/08/25.
//


import Foundation


struct ParticleBuilder: Sendable {
    private(set) var config: ParticleConfig
    
    init(
        name: String,
        runtime: any ParticleRuntime
    ) {
        self.config = .init(
            name: name,
            runtime: runtime
        )
    }
    
    @discardableResult
    mutating func spawnRate(_ v: Double) -> Self {
        config.spawnRate = v
        return self
    }
    
    @discardableResult
    mutating func lifetime(_ r: ClosedRange<Double>) -> Self {
        config.lifetime = r
        return self
    }
    
    @discardableResult
    mutating func opacity(_ v: Double) -> Self {
        config.opacity = v
        return self
    }
    
    @discardableResult
    mutating func speed(_ r: ClosedRange<Double>) -> Self {
        config.speed = r
        return self
    }
    
    @discardableResult
    mutating func angle(_ r: ClosedRange<Double>) -> Self {
        config.angle = r
        return self
    }
    
    @discardableResult
    mutating func depth(_ v: Double) -> Self {
        config.depth = v
        return self
    }
    
    @discardableResult
    mutating func priority(_ v: Int) -> Self {
        config.priority = v
        return self
    }
    @discardableResult
    mutating func categories(_ s: Set<ParticleCategory>) -> Self {
        config.categories = s
        return self
    }
    
    @discardableResult mutating func trigger(_ t: TriggerPredicate) -> Self {
        config.trigger = t
        return self
    }
}


extension ParticleBuilder {
    @discardableResult mutating func style(_ style: ParticleStyle) -> Self {
        switch style {
        case .rain: self.config.runtime = RainParticle(); self.config.categories = [.natural]
        case .dust: self.config.runtime = DustParticle(); self.config.categories = [.natural]
        case .sparkle: self.config.runtime = SparkleParticle(); self.config.categories = [.magical]
        case .glow: self.config.runtime = GlowParticle(); self.config.categories = [.magical]
        }
        return self
    }
}
