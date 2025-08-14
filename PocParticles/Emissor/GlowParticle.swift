//
//  GlowParticle.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 14/08/25.
//


import CoreGraphics
import SwiftUI

struct GlowParticle: ParticleRuntime {
    let id: String = "glow"
    
    init() {}
    
    func spawn(config: ParticleConfig, in rect: CGRect) -> [ParticleState] {
        let count = Int(config.spawnRate / 30.0)
        return (0..<count).map { _ in
            let pos = CGPoint(x: rect.midX, y: rect.midY)
            let vx = CGFloat.random(in: -10...10)
            let vy = CGFloat.random(in: -10...10)
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
            let rect = CGRect(x: p.position.x - 6, y: p.position.y - 6, width: 12, height: 12)
            ctx.fill(Path(ellipseIn: rect), with: .color(.blue.opacity(alpha)))
        }
    }
}
