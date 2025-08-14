//
//  RainParticle.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 14/08/25.
//


import CoreGraphics
import SwiftUI

struct RainParticle: ParticleRuntime {
    let id: String = "rain"
    
    init() {}
    
    func spawn(config: ParticleConfig, in rect: CGRect) -> [ParticleState] {
        let count = Int(config.spawnRate / 30.0) // roughly per frame @ 30fps
        return (0..<count).map { _ in
            let x = CGFloat.random(in: rect.minX...rect.maxX)
            let y = rect.minY - 10
            let speed = Double.random(in: config.speed)
            let angle = Double.random(in: config.angle)
            let vx = CGFloat(cos(angle) * speed)
            let vy = CGFloat(sin(angle) * speed)
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
            var path = Path()
            path.move(to: p.position)
            path.addLine(to: CGPoint(x: p.position.x, y: p.position.y + 8))
            ctx.stroke(path, with: .color(.white.opacity(alpha)), lineWidth: 1)
        }
    }
}
