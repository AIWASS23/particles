//
//  SnowParticle.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 20/08/25.
//

//import SwiftUI
//import CoreGraphics
//
//struct SnowParticle: ParticleRuntime {
//    let id: String = "snow"
//
//    init() {}
//
//    func spawn(config: ParticleConfig, in rect: CGRect) -> [ParticleState] {
//        let count = Int(config.spawnRate / 30.0)
//        return (0..<count).map { _ in
//            let pos = CGPoint(x: CGFloat.random(in: rect.minX...rect.maxX), y: rect.minY)
//            let vx = CGFloat.random(in: -10...10)
//            let vy = CGFloat.random(in: 20...40)
//            let life = Double.random(in: config.lifetime)
//            let rotation = CGFloat.random(in: 0...2*CGFloat.pi)
//            return ParticleState(position: pos, velocity: .init(dx: vx, dy: vy), life: life, maxLife: life, opacity: 1, rotation: rotation)
//        }
//    }
//
//    func update(dt: Double, state: inout [ParticleState]) {
//        for i in state.indices {
//            state[i].position.x += state[i].velocity.dx * dt
//            state[i].position.y += state[i].velocity.dy * dt
//            state[i].rotation += 0.5 * dt
//            state[i].life -= dt
//        }
//        state.removeAll { $0.life <= 0 }
//    }
//
//    func draw(in ctx: inout GraphicsContext, state: [ParticleState]) {
//        for p in state {
//            let rect = CGRect(x: p.position.x - 2, y: p.position.y - 2, width: 4, height: 4)
//            ctx.fill(Path(ellipseIn: rect), with: .color(.white.opacity(p.opacity)))
//        }
//    }
//}
