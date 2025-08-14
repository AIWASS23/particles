//
//  DustParticle.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 14/08/25.
//


import CoreGraphics
import SwiftUI

struct DustParticle: ParticleRuntime {
    let id: String = "dust"
    
    init() {}
    
    func spawn(config: ParticleConfig, in rect: CGRect) -> [ParticleState] {
        let count = Int(config.spawnRate / 30.0)
        return (0..<count).map { _ in
            let x = CGFloat.random(in: rect.minX...rect.maxX)
            let y = CGFloat.random(in: rect.minY...rect.maxY)
            let vx = CGFloat.random(in: -10...10)
            let vy = CGFloat.random(in: -10...10)
            let life = Double.random(in: config.lifetime)
            return ParticleState(position: CGPoint(x: x, y: y), velocity: .init(dx: vx, dy: vy), life: life, maxLife: life, opacity: config.opacity)
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
            let rect = CGRect(x: p.position.x, y: p.position.y, width: 2, height: 2)
            ctx.fill(Path(ellipseIn: rect), with: .color(.yellow.opacity(alpha)))
        }
    }
}
