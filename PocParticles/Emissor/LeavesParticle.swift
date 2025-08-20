//
//  LeavesParticle.swift
//  PocParticles
//
//  Created by Marcelo deAraújo on 20/08/25.
//

//import SwiftUI
//import CoreGraphics
//
//struct LeavesParticle: ParticleRuntime {
//    let id: String = "leaves"
//
//    init() {}
//
//    func spawn(config: ParticleConfig, in rect: CGRect) -> [ParticleState] {
//        let count = Int(config.spawnRate / 30.0)
//        return (0..<count).map { _ in
//            let pos = CGPoint(x: CGFloat.random(in: rect.minX...rect.maxX), y: rect.minY)
//            let vx = CGFloat.random(in: -20...20)
//            let vy = CGFloat.random(in: 10...30)
//            let life = Double.random(in: config.lifetime)
//            let rotation = CGFloat.random(in: 0...2*CGFloat.pi)
//            let rotationSpeed = CGFloat.random(in: -1...1)
//            return ParticleState(position: pos, velocity: .init(dx: vx, dy: vy), life: life, maxLife: life, opacity: 1, rotation: rotation, rotationSpeed: rotationSpeed)
//        }
//    }
//
//    func update(dt: Double, state: inout [ParticleState]) {
//        for i in state.indices {
//            state[i].position.x += state[i].velocity.dx * dt
//            state[i].position.y += state[i].velocity.dy * dt
//            state[i].rotation += state[i].rotationSpeed * dt
//            state[i].life -= dt
//        }
//        state.removeAll { $0.life <= 0 }
//    }
//
//    func draw(in ctx: inout GraphicsContext, state: [ParticleState]) {
//        for p in state {
//            let size: CGFloat = 6
//            let rect = CGRect(x: p.position.x - size/2, y: p.position.y - size/2, width: size, height: size)
//            ctx.rotate(by: p.rotation, around: p.position)
//            ctx.fill(Path(ellipseIn: rect), with: .color(.green.opacity(p.opacity)))
//        }
//    }
//}
