//
//  SparkleParticle.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 14/08/25.
//


import CoreGraphics
import SwiftUI

struct SparkleParticle: ParticleRuntime {
    let id: String = "sparkle"
    
    init() {}
    
    func spawn(config: ParticleConfig, in rect: CGRect) -> [ParticleState] {
        let count = Int(config.spawnRate / 30.0)
        return (0..<count).map { _ in
            let pos = CGPoint(x: CGFloat.random(in: rect.minX...rect.maxX), y: CGFloat.random(in: rect.minY...rect.maxY))
            let vx = CGFloat.random(in: -30...30)
            let vy = CGFloat.random(in: -30...30)
            let life = Double.random(in: config.lifetime)
            return ParticleState(position: pos, velocity: .init(dx: vx, dy: vy), life: life, maxLife: life, opacity: config.opacity)
        }
    }
    
    func update(dt: Double, state: inout [ParticleState]) {
        for i in state.indices {
            state[i].position.x += state[i].velocity.dx * dt
            state[i].position.y += state[i].velocity.dy * dt
            state[i].life -= dt
        }
        state.removeAll { $0.life <= 0 }
    }
    
    func draw(in ctx: inout GraphicsContext, state: [ParticleState]) {
        for p in state {
            let alpha = p.opacity * max(0, p.life / p.maxLife)
            let rect = CGRect(x: p.position.x - 1, y: p.position.y - 1, width: 2, height: 2)
            ctx.fill(Path(ellipseIn: rect), with: .color(.white.opacity(alpha)))
        }
    }
}
