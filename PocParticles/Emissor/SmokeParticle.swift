//
//  SmokeParticle.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 20/08/25.
//

import SwiftUI
import CoreGraphics


struct SmokeParticle: ParticleRuntime {
    let id: String = "smoke"

    init() {}

    func spawn(config: ParticleConfig, in rect: CGRect) -> [ParticleState] {
        let count = Int(config.spawnRate / 30.0)
        return (0..<count).map { _ in
            let pos = CGPoint(x: rect.midX + CGFloat.random(in: -10...10), y: rect.maxY)
            let vx = CGFloat.random(in: -20...20)
            let vy = CGFloat.random(in: -60 ... -30)
            let life = Double.random(in: config.lifetime)
            return ParticleState(position: pos, velocity: .init(dx: vx, dy: vy), life: life, maxLife: life, opacity: 0.5)
        }
    }

    func update(dt: Double, state: inout [ParticleState]) {
        for i in state.indices {
            state[i].position.x += state[i].velocity.dx * dt
            state[i].position.y += state[i].velocity.dy * dt
            state[i].life -= dt
            state[i].opacity *= 0.99 // fading gradual
        }
        state.removeAll { $0.life <= 0 }
    }

    func draw(in ctx: inout GraphicsContext, state: [ParticleState]) {
        for p in state {
            let radius = CGFloat(10 + 10*(1 - p.life / p.maxLife))
            ctx.fill(Path(ellipseIn: CGRect(x: p.position.x - radius/2, y: p.position.y - radius/2, width: radius, height: radius)), with: .color(.gray.opacity(p.opacity)))
        }
    }
}
