import Foundation



//struct ParticleBuilder: Sendable {
//    private(set) var config: ParticleConfig
//    
//    init(
//        name: String,
//        runtime: any ParticleRuntime
//    ) {
//        self.config = .init(
//            name: name,
//            runtime: runtime
//        )
//    }
//    
//    @discardableResult
//    mutating func spawnRate(_ v: Double) -> Self {
//        config.spawnRate = v
//        return self
//    }
//    
//    @discardableResult
//    mutating func lifetime(_ r: ClosedRange<Double>) -> Self {
//        config.lifetime = r
//        return self
//    }
//    
//    @discardableResult
//    mutating func opacity(_ v: Double) -> Self {
//        config.opacity = v
//        return self
//    }
//    
//    @discardableResult
//    mutating func speed(_ r: ClosedRange<Double>) -> Self {
//        config.speed = r
//        return self
//    }
//    
//    @discardableResult
//    mutating func angle(_ r: ClosedRange<Double>) -> Self {
//        config.angle = r
//        return self
//    }
//    
//    @discardableResult
//    mutating func depth(_ v: Double) -> Self {
//        config.depth = v
//        return self
//    }
//    
//    @discardableResult
//    mutating func priority(_ v: Int) -> Self {
//        config.priority = v
//        return self
//    }
//    @discardableResult
//    mutating func categories(_ s: Set<ParticleCategory>) -> Self {
//        config.categories = s
//        return self
//    }
//    
//    @discardableResult mutating func trigger(_ t: TriggerPredicate) -> Self {
//        config.trigger = t
//        return self
//    }
//}
//
//
//extension ParticleBuilder {
//    @discardableResult mutating func style(_ style: ParticleStyle) -> Self {
//        switch style {
//        case .rain: self.config.runtime = RainParticle(); self.config.categories = [.natural]
//        case .dust: self.config.runtime = DustParticle(); self.config.categories = [.natural]
//        case .sparkle: self.config.runtime = SparkleParticle(); self.config.categories = [.magical]
//        case .glow: self.config.runtime = GlowParticle(); self.config.categories = [.magical]
//        }
//        return self
//    }
//}

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
    func spawnRate(_ v: Double) -> Self {
        var copy = self
        copy.config.spawnRate = v
        return copy
    }
    
    @discardableResult
    func lifetime(_ r: ClosedRange<Double>) -> Self {
        var copy = self
        copy.config.lifetime = r
        return copy
    }
    
    @discardableResult
    func opacity(_ v: Double) -> Self {
        var copy = self
        copy.config.opacity = v
        return copy
    }
    
    @discardableResult
    func speed(_ r: ClosedRange<Double>) -> Self {
        var copy = self
        copy.config.speed = r
        return copy
    }
    
    @discardableResult
    func angle(_ r: ClosedRange<Double>) -> Self {
        var copy = self
        copy.config.angle = r
        return copy
    }
    
    @discardableResult
    func depth(_ v: Double) -> Self {
        var copy = self
        copy.config.depth = v
        return copy
    }
    
    @discardableResult
    func priority(_ v: Int) -> Self {
        var copy = self
        copy.config.priority = v
        return copy
    }
    
    @discardableResult
    func categories(_ s: Set<ParticleCategory>) -> Self {
        var copy = self
        copy.config.categories = s
        return copy
    }
    
    @discardableResult
    func trigger(_ t: TriggerPredicate) -> Self {
        var copy = self
        copy.config.trigger = t
        return copy
    }
}

extension ParticleBuilder {
    @discardableResult
    func style(_ style: ParticleStyle) -> Self {
        var copy = self
        switch style {
        case .rain:
            copy.config.runtime = RainParticle()
            copy.config.categories = [.natural]
        case .dust:
            copy.config.runtime = DustParticle()
            copy.config.categories = [.natural]
        case .sparkle:
            copy.config.runtime = SparkleParticle()
            copy.config.categories = [.magical]
        case .glow:
            copy.config.runtime = GlowParticle()
            copy.config.categories = [.magical]
        case .fire:
            copy.config.runtime = FireParticle()
            copy.config.categories = [.magical]
        case .smoke:
            copy.config.runtime = SmokeParticle()
            copy.config.categories = [.ui]
        }
        return copy
    }
}

